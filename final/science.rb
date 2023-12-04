class ScientificPublication
    attr_accessor :name, :author, :date_of_publishing, :number_of_pages, :keywords, :sources
  
    def initialize(name, author, date_of_publishing, number_of_pages)
      @name = name
      @author = author
      @date_of_publishing = date_of_publishing
      @number_of_pages = number_of_pages
      @keywords = []
      @sources = []
    end
  
    def display
      puts "Name: #{@name}"
      puts "Author: #{@author}"
      puts "Date of Publishing: #{@date_of_publishing}"
      puts "Number of Pages: #{@number_of_pages}"
      puts "Keywords: #{@keywords.join(', ')}"
      puts "Sources: #{display_sources}"
    end
  
    private
  
    def display_sources
      if @sources.empty?
        "None"
      else
        @sources.map { |source| source.name }.join(', ')
      end
    end
  end
  
  class BiologyPublication < ScientificPublication
    attr_accessor :biology_field
  
    def initialize(name, author, date_of_publishing, number_of_pages, biology_field)
      super(name, author, date_of_publishing, number_of_pages)
      @biology_field = biology_field
    end
  
    def display
      super
      puts "Biology Field: #{@biology_field}"
    end
  end
  
  class PhysicsPublication < ScientificPublication
    attr_accessor :physics_field
  
    def initialize(name, author, date_of_publishing, number_of_pages, physics_field)
      super(name, author, date_of_publishing, number_of_pages)
      @physics_field = physics_field
    end
  
    def display
      super
      puts "Physics Field: #{@physics_field}"
    end
  end
  
  class ChemistryPublication < ScientificPublication
    attr_accessor :chemistry_field
  
    def initialize(name, author, date_of_publishing, number_of_pages, chemistry_field)
      super(name, author, date_of_publishing, number_of_pages)
      @chemistry_field = chemistry_field
    end
  
    def display
      super
      puts "Chemistry Field: #{@chemistry_field}"
    end
  end
  
  class Library
    attr_accessor :publications
  
    def initialize
      @publications = []
    end
  
    def add_publication(publication)
      @publications << publication
    end

    def search_by_author(search_parameters)
        matching_publications = @publications.select do |publication|
          publication.author.downcase.include?(search_parameters.downcase)
        end
    
        display_search_results(matching_publications, "Author: #{search_parameters}")
      end
    
      def search_by_keywords(search_parameters)
        matching_publications = @publications.select do |publication|
          publication.keywords.any? { |keyword| keyword.downcase.include?(search_parameters.downcase) }
        end
    
        display_search_results(matching_publications, "Keywords: #{search_parameters}")
      end
    
      private
    
      def display_search_results(publications, search_criteria)
        sorted_publications = publications.sort_by do |publication|
          relevancy_score(publication, search_criteria)
        end.reverse
    
        if sorted_publications.empty?
          puts "No publications found with #{search_criteria}."
        else
          puts "Publications found with #{search_criteria}, sorted by relevancy:"
          sorted_publications.each do |publication|
            puts "=== #{publication.class.name} ==="
            publication.display
            puts "====================="
          end
        end
      end
    
      def relevancy_score(publication, search_criteria)
        if search_criteria.start_with?("Author:")
          # Calculate relevancy score based on the number of matching characters in the author's name
          matching_characters = publication.author.downcase.scan(search_criteria.gsub("Author:", "").downcase).join('').length
          matching_characters * 10
        elsif search_criteria.start_with?("Keywords:")
          # Calculate relevancy score based on the number of matching keywords
          publication.keywords.count { |keyword| keyword.downcase.include?(search_criteria.gsub("Keywords:", "").downcase) }
        else
          0
        end
      end
  end
require 'minitest/autorun'

class TestLibrary < Minitest::Test
  def setup
    @library = Library.new

    # Adding Biology Publication
    @biology_paper = BiologyPublication.new('Biology Paper', "John John", '2023-01-01', 10, 'Genetics')
    @biology_paper.keywords = ['Genetics', 'Biology']
    @library.add_publication(@biology_paper)

    # Adding Physics Publication
    @physics_paper = PhysicsPublication.new('Physics Paper', "Bob John", '2023-02-01', 15, 'Quantum Mechanics')
    @physics_paper.keywords = ['Physics', 'Quantum']
    @physics_paper.sources = [@biology_paper]
    @library.add_publication(@physics_paper)

    # Adding Chemistry Publication
    @chemistry_paper = ChemistryPublication.new('Chemistry Paper', "Den John", '2023-03-01', 12, 'Organic Chemistry')
    @chemistry_paper.keywords = ['Chemistry', 'Organic Chemistry']
    @chemistry_paper.sources = [@physics_paper, @biology_paper]
    @library.add_publication(@chemistry_paper)
  end

  def test_search_by_author
    results = @library.search_by_author('John')
    assert_equal 3, results.length
    assert_equal @biology_paper, results[0]
    assert_equal @physics_paper, results[2]
    assert_equal @chemistry_paper, results[1]
  end

  def test_search_by_keywords
    results = @library.search_by_keywords('Physics')
    assert_equal 1, results.length
    assert_equal @physics_paper, results[0]
  end

  def test_relevancy_score_author
    score = @library.send(:relevancy_score, @biology_paper, 'Author: John')
    assert_equal 50, score
  end

  def test_relevancy_score_keywords
    score = @library.send(:relevancy_score, @physics_paper, 'Keywords: Physics')
    assert_equal 0, score
  end
end