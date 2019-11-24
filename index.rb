# Solution STARTs
require 'sqlite3'
begin

  # setup DB connection
  @db = SQLite3::Database.open "tent_house.db"

  # create table Items if not exists
  @db.execute "CREATE TABLE IF NOT EXISTS Items(Id INTEGER PRIMARY KEY, Name TEXT, total_quantity INT, booked_quantity INT)"

  # create table Transactions if not exists
  @db.execute "CREATE TABLE IF NOT EXISTS Transactions(Id INTEGER PRIMARY KEY, Type varchar(10), Quantity INT, item_id INT, date_time DATETIME)"

  # Avaliable options
  def main
    puts "Choose Your option:"
    option = gets.to_i

    case option
    when 1
      show_list
    when 2
      book_item
    when 3
      return_item
    when 4
      show_transactions
    when 5
      tent_house_help
    when 9
      exit_tent_house
    else
      option_not_avaliable
    end
  end

  # Show Item list  
  def show_list
    items = @db.execute "SELECT * FROM Items"

    unless items.empty?
      puts "Item ID \tItem Name \tAvailable Quantity"

      items.each do |item|
        if (item[2] - item[3]) > 0
          puts "#{item[0]} \t #{item[1]} \t #{item[2] - item[3]}"
        end
      end
    else
      puts "Oops!! Item list is empty for now"
    end

    main_with_line_break 
  end

  # Book an Item
  def book_item
    puts "Enter Item ID:"
    item_id = gets.to_i

    item = (@db.execute "SELECT * FROM Items WHERE ID=#{item_id} LIMIT 1").first

    if item
      puts "Enter Quantity[#{item[1]}]:"
      qty = gets.to_i

      if qty > item[2]
        puts "Error: Goes beyond quantity available for this item"
      else
        @db.execute "INSERT INTO Transactions VALUES(null, 'OUT', #{qty}, #{item_id}, datetime('now'))"
        last_txn = @db.execute "SELECT last_insert_rowid()"
        @db.execute "UPDATE Items SET booked_quantity = #{item[3] + qty}
                    WHERE id=#{item_id}"

        puts "Success: Booking request accepted - Transaction ID: #{last_txn[0][0]}"
      end
    else
      puts "Oops!! No Item found for ID: #{item_id}"
    end

    puts "Book Another Item [y/n]:"
    response = gets.chomp()

    book_item if response.eql? "y"

    main_with_line_break
  end

  # Return an Item
  def return_item
    puts "Enter Transaction ID:"
    txn_id = gets.to_i

    txn = (@db.execute "SELECT * FROM Transactions WHERE Id=#{txn_id} AND Type != 'IN' LIMIT 1").first

    if txn
      item = (@db.execute "SELECT * FROM Items WHERE Id=#{txn[3]} LIMIT 1").first
      already_return = (@db.execute "SELECT * FROM Transactions WHERE item_id=#{item[0]} AND Type = 'IN' LIMIT 1").first

      if item && !already_return
        puts "Confirm Return (y/n):"
        response = gets.chomp()

        if response.eql? "y"
          @db.execute "INSERT INTO Transactions VALUES(null, 'IN', #{txn[2]}, #{item[0]}, datetime('now'))"
          last_txn = @db.execute "SELECT last_insert_rowid()"
          @db.execute "UPDATE Items SET booked_quantity = #{item[3] - txn[2]}
                      WHERE id=#{item[0]}"

          puts "Success: Return request accepted - Transaction ID: #{last_txn[0][0]}"
          puts "Return Another Item [y/n]:"
          another_return = gets.chomp()

          return_item if another_return.eql? "y"
        end
      else
        puts "Failure: Already Returned"
      end
    else
      puts "Failure: Invalid Transaction ID/ Already Returned"
    end

    main_with_line_break
  end

  # Show All Items with Transactions
  def show_transactions
    items = @db.execute "SELECT * FROM Items"

    items.each do |item|
      puts "Item Name: #{item[1]}"
      puts "Available Quantity: #{item[2] - item[3]}"

      transactions = @db.execute "SELECT * FROM Transactions WHERE item_id = #{item[0]}"

      unless transactions.empty?
        puts "\nTransaction ID \t Date/time \t Type \t Quantity"

        transactions.each do |txn|
          puts "#{txn[0]} \t #{txn[4]} \t #{txn[1]} \t #{txn[2]}"
        end
      end

      puts "---"
    end

    main_with_line_break
  end

  # Db connection close & Exit from Tent House Rental
  def exit_tent_house
    puts "Are you sure you want to Exit [y/n]"
    key_in = gets.chomp()

    if key_in.eql? "y"
      @db.close if @db

      puts "Thanks for using 'Tent House Rental'"
      puts "Exiting..."

      return
    else
      main
    end
  end

  # Tent House Help
  def tent_house_help
    puts "Show Item List: 1"
    puts "Book an Item: 2"
    puts "Return a Item: 3"
    puts "Show all Items & Transactions: 4"
    puts "Tent House Rental help: 5"
    puts "Exit from Tent House Rental: 9"

    main_with_line_break
  end

  # Option not Avaliable
  def option_not_avaliable
    puts "Sorry: option not available \nEnter 5 for help or 9 to Exit"
    puts "\n"

    main 
  end

  def main_with_line_break
    puts "--------------------------------------------------------------------"
    puts "\n"

    main
  end

  puts "*******************[ Welcome to 'Rental Tent House' ]*******************"
  main
 
  # SQLite erorr handling    
  rescue SQLite3::Exception => e 
    puts "Exception occurred"
    puts e
  ensure
    @db.close if @db
end
# Solution STARTs