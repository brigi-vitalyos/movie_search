require 'rails_helper'

RSpec.describe MoviesHelper, type: :helper do

  describe "#pagination_ranges" do
    subject(:ranges) { helper.pagination_ranges(current_page, total_pages) }
    let(:current_page) { 1 }

    context 'when total pages is less than 15' do
      let(:total_pages) { 14 }

      it 'returns one range with all pages' do
        expect(ranges).to eq [(1..total_pages)]
      end
    end

    context 'when total pages is greater than 15' do
      let(:total_pages) { 24 }

      (1..2).each do |page|
        context "when current page is #{page}" do
          let(:current_page) { page }

          it 'returns two ranges with the first 3 and last 3 pages' do
            expect(ranges).to eq [(1..3), (total_pages-2..total_pages)]
          end
        end
      end

      context 'when current page is 3' do
        let(:current_page) { 3 }
        it 'returns with the extended first and the initial last range' do
          expect(ranges).to eq [(1..current_page+1), (total_pages-2..total_pages)]
        end
      end

      context 'when current page is the first page of the last range' do
        let(:current_page) { total_pages - 2 }

        it 'returns with the extended last and the initial first range' do
          expect(ranges).to eq [(1..3), (total_pages-3..total_pages)]
        end
      end

      context 'when current page is the part of the last range' do
        let(:current_page) { total_pages - 1 }

        it 'returns with the initial first and last range' do
          expect(ranges).to eq [(1..3), (total_pages-2..total_pages)]
        end
      end

      context 'when current page is the last page' do
        let(:current_page) { total_pages }

        it 'returns with the initial first and last range' do
          expect(ranges).to eq [(1..3), (total_pages-2..total_pages)]
        end
      end

      context 'when current page is between the 2 initial ranges' do
        let(:current_page) { 16 }

        it 'returns with an extra range for the current page' do
          expect(ranges).to eq [(1..3), (current_page-1..current_page+1), (total_pages-2..total_pages)]
        end
      end
    end
  end
end
