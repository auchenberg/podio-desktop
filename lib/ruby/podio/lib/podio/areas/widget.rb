module Podio
  module Widget
    include Podio::ResponseWrapper
    extend self

    def create(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/widget/#{ref_type}/#{ref_id}/"
        req.body = attributes
      end

      response.body['widget_id']
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/widget/#{id}"
        req.body = attributes
      end

      response.status
    end

    def delete(id)
      Podio.connection.delete("/widget/#{id}").status
    end

    def update_order(ref_type, ref_id, widget_list)
      response = Podio.connection.put do |req|
        req.url "/widget/#{ref_type}/#{ref_id}/order"
        req.body = widget_list
      end

      response.status
    end

    def find(id)
      member Podio.connection.get("/widget/#{id}").body
    end

    def find_all_for_reference(ref_type, ref_id)
      list Podio.connection.get("/widget/#{ref_type}/#{ref_id}/display/").body
    end
  end
end
