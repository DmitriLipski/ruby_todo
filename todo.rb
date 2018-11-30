module Menu
  def menu
    " Welcome to the TodoList Program!
      This menu will help you use the Task List System
      1) Add
      2) Show
      3) Update
      4) Delete
      5) Write to a File
      6) Read from a File
      7) Toggle status
      Q) Quit "
  end

  def show
    menu
  end
end

module Promptable
  def prompt(message = 'What would you like to do?', symbol = ':> ')
    print message
    print symbol
    gets.chomp
  end
end

class List
  attr_reader :all_tasks
  def initialize
    @all_tasks = []
  end

  def add(task)
    all_tasks << task
  end

  def show
    puts 'Your task list:'
    all_tasks.map.with_index { |l, i| puts "(#{i.next}): #{l.to_machine}"}
  end

  def update(task_number, newTask)
    all_tasks[task_number - 1] = newTask
  end

  def write_to_file(filename)
    machinified = @all_tasks.map(&:to_machine).join("\n")
    IO.write(filename, machinified)
  end

  def read_from_file(filename)
    IO.readlines(filename).each do |line|
      status, *description = line.split(':')
      status = status.include?('X')
      add(Task.new(description.join(':').strip, status))
    end
  end

  def delete(task_number)
    all_tasks.delete_at(task_number - 1)
  end

  def toggle(task_number)
    puts "In List we change a task of
            #{all_tasks[task_number - 1].inspect}"
    all_tasks[task_number - 1].toggle_status
    puts "Now our task has this information
            #{all_tasks[task_number - 1].inspect}"
  end
end

class Task
  attr_reader :description
  attr_accessor :status
  def initialize(description, status = false)
    @description = description
    @status = status
  end

  def to_s
    description
  end

  def completed?
    status
  end

  def to_machine
    "#{represent_status}:#{description}"
  end

  def toggle_status
    @status = !completed?
  end

  private
  def represent_status
    "#{completed? ? '[X]' : '[ ]'}"
  end
end


if __FILE__ == $PROGRAM_NAME
  include Menu
  include Promptable
  my_list = List.new
  puts 'Please choose from the following list:'
    until ['q'].include?(user_input = prompt(show).downcase)
      case user_input
      when '1'
        my_list.add(Task.new(prompt('What is the task you would
              like to accomplish?')))
      when '2'
        my_list.show
      when '3'
        my_list.update(prompt('Enter task number you want update:').to_i, Task.new(prompt('What is the task you would
              like to accomplish?')))
      when '4'
        my_list.show
        my_list.delete(prompt('Enter task number you want delete:').to_i)
      when '5'
        my_list.write_to_file(prompt('What is the filename
              to write to?'))
      when '6'
        begin
          my_list.read_from_file(prompt('What is the filename to
                  read from?'))
        rescue Errno::ENOENT
          puts 'File name not found, please verify your file name
                  and path.'
        end
      when '7'
        my_list.show
        my_list.toggle(prompt('Enter task number you want toggle:').to_i)
      else
        puts 'Sorry, I did not understand'
      end
      prompt('Press enter to continue', '')
    end
  puts 'Outro - Thanks for using the menu system!'
end