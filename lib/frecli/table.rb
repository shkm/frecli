require 'terminal-table'

class Frecli
  module Table
    # Table where heading is in the first row,
    # and values are in the columns
    #
    # When records  =  [ { id: 1, name: 'Hello', body: 'Hello, world!' } ]
    #      headings =  'ID', 'Name', 'Body']
    #      values   =  [ :id, :name, :body]
    # +----------------------------+
    # | ID | Name  | Body          |
    # +----------------------------+
    # | 1  | Hello | Hello, world! |
    # +----------------------------+
    def self.vertical(records, headings, values)
      Terminal::Table.new do |table|

        table.headings = headings
        table.rows = records.map do |record|
          values.map { |value| table_item(record, value)}
        end
      end
    end

    # Table where heading is in the first column,
    # and value in the second.
    #
    # When records = [ { id: 1, name: 'Hello', body: 'Hello, world!' } ]
    #      items   = [ { ID: :id, Name: :name, Body: :body } ]
    # +----------------------+
    # | ID   | 1             |
    # | Name | Hello         |
    # | Body | Hello, world! |
    # +----------------------+
    def self.horizontal(record, items)
      Terminal::Table.new do |table|
        table.rows = items.map do |name, value|
          [name, table_item(record, value)]
        end
      end
    end

    # When record = { id: 1, name: 'Hello', body: 'Hello, world!' }
    #
    #      value  = :id
    #            => 1
    #
    #      value  = -> (record) { record.name.upcase }
    #            => 'HELLO'
    #
    #      value  = 'foo'
    #            => 'foo'
    def self.table_item(record, value)
      return record[value] if value.is_a? Symbol
      return value[record] if value.respond_to? :call

      value
    end
  end
end
