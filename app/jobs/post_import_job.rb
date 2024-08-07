class PostImportJob < ApplicationJob
  queue_as :default

  require 'csv'
  def perform(file)
    CSV.foreach(file.path, headers: true) do |row|
      Post.create!(row.to_hash)
    end
  end
end
