require 'ancestry'

class MoveMiqSetMemberships < ActiveRecord::Migration[5.0]
  class Relationship < ActiveRecord::Base
    has_ancestry
  end

  class MiqSetMembership < ActiveRecord::Base
  end

  def up
    say_with_time("Converting set relationships to miq_set_memberships") do
      sets = Relationship.where(:relationship => "membership").roots

      sets.each do |set|
        members = set.children
        members.each do |member|
          MiqSetMembership.create!(
            :miq_set_id  => set.resource_id,
            :member_type => member.resource_type,
            :member_id   => member.resource_id
          )
        end
        members.delete_all
      end
      sets.delete_all
    end
  end

  def down
  end
end
