module MoviesHelper

  def pagination_ranges(current_page, total_pages)
    if total_pages > 15
      generate_ranges(current_page.to_i, total_pages)
    else
      [(1..total_pages)]
    end
  end

  def poster_url_for(movie)
    if movie.poster_path.present?
      "https://image.tmdb.org/t/p/original/#{movie.poster_path}"
    else
      "https://placehold.co/1400x2100?text=#{movie.title}&font=roboto"
    end
  end

  private

  def generate_ranges(current_page, total_pages)
    start_range = (1..3)
    end_range = (total_pages-2..total_pages)

    if start_range.first(2).include?(current_page) || end_range.last(2).include?(current_page)
      [(1..3), (total_pages-2..total_pages)]
    elsif (start_range.last..start_range.last+5).include? current_page
      [(1..current_page+1), (total_pages-2..total_pages)]
    elsif (end_range.first-5..end_range.first).include? current_page
      [(1..3), ((current_page-1)..total_pages)]
    else
      [(1..3), ((current_page-1)..(current_page+1)),(total_pages-2..total_pages)]
    end
  end
end
