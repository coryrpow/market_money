class MarketVendor < ApplicationRecord
  validates :market_id, presence: true
  validates :vendor_id, presence: true
  validates :market_id, uniqueness: {
   scope: :vendor_id,
   message: ->(object, data) { "vendor association between market with market_id=#{object.market_id} and vendor_id=#{object.vendor_id} already exists" }
 }
  belongs_to :market
  belongs_to :vendor
end