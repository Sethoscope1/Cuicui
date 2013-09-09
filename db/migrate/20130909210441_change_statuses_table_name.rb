class ChangeStatusesTableName < ActiveRecord::Migration
  def change

    rename_table('status', 'statuses')

  end
end
