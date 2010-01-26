require 'rubygems'
require "test/spec"
require "munkres"

context "An empty Munkres instance" do
  
  setup do
    @saved_protected_instance_methods = Munkres.protected_instance_methods
    x = @saved_protected_instance_methods
    Munkres.class_eval { public *x }
    @m = Munkres.new [[0]]
  end
  
  teardown do
     x = @saved_protected_instance_methods
     Munkres.class_eval { protected *x }
   end
  
  specify "should track a matrix of values" do
    @m.matrix.should == [[0]]
  end
  
  specify "should track covered columns" do
    @m.covered_columns.should == []
  end
  
  specify "should track covered rows" do
    @m.covered_rows.should == []
  end
  
  specify "should track starred zeros" do
    @m.starred_zeros.should == []
  end
  
  specify "should track primed zeros" do
    @m.primed_zeros.should == []
  end
end

context "A Munkres solving instance" do
  setup do
    @saved_protected_instance_methods = Munkres.protected_instance_methods
    x = @saved_protected_instance_methods
    Munkres.class_eval { public *x }
    @m = Munkres.new [[1,2,3],[2,4,6],[3,6,9]]
  end
  
  teardown do
    x = @saved_protected_instance_methods
    Munkres.class_eval { protected *x }
  end
  
  specify "create_zero_in_rows should create a zero in each row of the matrix" do
    @m.create_zero_in_rows
    @m.matrix.should == [[0,1,2],[0,2,4],[0,3,6]]
  end
  
  specify "should be able to retrieve any row of the matrix" do
    @m.matrix.row(2).should == [3,6,9]
  end
  
  specify "should be able to retrieve any column of the matrix" do
    @m.matrix.column(1).should == [2,4,6]
  end
  
  specify "should be able to find the min value of any collection" do
    @m.min_or_zero([3,0,2,1]).should == 0
  end
  
  specify "star_zeros should star the first zero in this example" do
    @m.create_zero_in_rows
    @m.star_zeros
    @m.starred_zeros.should == [[0,0]]
  end  
  
  specify "star_in_column? should indicate a star in a column" do
    @m.starred_zeros << [0,0]
    @m.star_in_column?(0).should.be true
    @m.star_in_column?(1).should.be false
  end
  
  specify "star_in_row? should indicate a star in a row" do
    @m.starred_zeros << [0,1]
    @m.star_in_row?(0).should.be true
    @m.star_in_row?(1).should.be false
  end
  
  specify "cover_columns_with_stars should cover the first colum" do
    @m.create_zero_in_rows
    @m.star_zeros
    @m.cover_columns_with_stars
    @m.covered_columns.should == [0]
  end
  
  specify "should be done if all columns are covered" do
    @m.done?.should.be false
    @m.covered_columns = [0,1,2]
    @m.done?.should.be true
  end
  
  specify "should be able to prime the first uncovered zero" do
    @m.matrix[0][1] = 0
    @m.matrix[1][1] = 0
    @m.prime_first_uncovered_zero.should == [0,1]
    @m.primed_zeros.should == [[0,1]]
  end
  
  specify "should be able to find the smallest uncovered value" do
    @m.covered_columns = [0,1]
    @m.covered_rows = [0]
    @m.smallest_uncovered_value.should == 6
  end
  
  specify "should be able to add a value to covered rows an subtract it from uncovered columns" do
    @m.covered_columns = [1]
    @m.covered_rows = [0,2]
    @m.add_and_subtract_for_step_6(2)
    @m.matrix.should == [[1,4,3],[0,4,4],[3,8,9]]
  end
  
  specify "should construct a series of primed and starred zeros and reset things" do
    @m.matrix = [[0,0,1],[0,1,3],[0,2,5]]
    @m.covered_rows = [0]
    @m.starred_zeros = [[0,0]]
    @m.primed_zeros = [[0,1], [1,0]]
    @m.find_better_stars [1,0]
    [[0,1], [1,0]].each {|star| @m.starred_zeros.should.include star } 
    @m.primed_zeros.should.be.empty
    @m.covered_rows.should.be.empty
    @m.covered_columns.should.be.empty
  end
  
  specify "should return a list of optimal pairings" do
    optimal_pairings = [[0,2],[1,1],[2,0]]
    @m.find_pairings.sort.should == optimal_pairings.sort
  end
  
end

context "An oddly shaped Munkres matrix" do 
  setup do
    @saved_protected_instance_methods = Munkres.protected_instance_methods
    x = @saved_protected_instance_methods
    Munkres.class_eval { public *x }
  end
  
  teardown do
    x = @saved_protected_instance_methods
    Munkres.class_eval { protected *x }
  end
  
  specify "should zero pad a tall skinny on initialize" do
    m = Munkres.new [[1,2],[2,4],[3,6]]
    
    m.matrix.should == [[1,2,0],[2,4,0],[3,6,0]]
  end
  
  specify "should raise an error for wide inputs" do
    should.raise(ArgumentError) { Munkres.new [[1,2,3],[4,5,6]] }
  end
  
  specify "should raise an error for irregular inputs" do
    should.raise(ArgumentError) { Munkres.new [[1,2],[1,2,3]] }
  end
  
  specify "should raise an error for an empty matrix" do
    should.raise(ArgumentError) { Munkres.new [] }
  end
  
  specify "should raise an error for an empty row" do
    should.raise(ArgumentError) { Munkres.new [[],[]] }
  end
end
    


context "Complex examples with know solutions" do
  specify "should solve first example" do
    optimal_pairings = [[0,5],[1,1],[2,2],[3,3],[4,4],[5,0]]
    m = Munkres.new [[3,4,5,6,2,1],[3,0,1,2,3,4],[7,6,0,2,1,1],[4,4,5,0,1,2],[0,1,0,1,0,0],[0,3,2,2,2,0]]
    
    m.find_pairings.sort.should == optimal_pairings.sort
    
  end

  specify "should solve a larger example" do
    optimal_pairings = []
    m = Munkres.new [[4,1,2,3],
    [6,9,2,4],
    [1,0,3,7],
    [10,4,6,6]]
    m.find_pairings
    m.total_cost_of_pairing.should == 10
  end  
  
  specify "should solve a non-square example" do
   optimal_pairings = [[[0, 3], [1, 2], [2, 1], [5, 0]],
                       [[0, 1], [1, 2], [2, 0], [5, 3]]]    
    m = Munkres.new [[4,1,2,3],
    [6,9,2,4],
    [1,0,3,7],
    [10,4,6,6],
    [5,7,5,9],
    [2,2,14,3]]
    optimal_pairings.sort.should.include m.find_pairings.sort
    m.total_cost_of_pairing.should == 7
  end
  
  specify "should solve a very large example" do
    # Profile the code
    #require 'ruby-prof'
    
    arr = []
    100.times do |i|
      arr[i] = []
      100.times do |j|
        arr[i][j] = rand 20
      end
    end
    
    #result = RubyProf.profile do
      m = Munkres.new arr
      m.find_pairings
    #end

    #printer = RubyProf::GraphHtmlPrinter.new(result)
    #File.open('profile.html', 'w') do |file|
    #  printer.print(file, {:min_percent => 30, :print_file => true})
    #end
    
        
  end
  
end