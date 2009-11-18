# ActiveMerchant Instrumentation.

if defined? Net::HTTP
  Net::HTTP.class_eval do
    def request_with_newrelic_trace(*args)
      if Thread::current[:newrelic_scope_stack].nil?
        self.class.trace_execution_unscoped(["External/#{@address}/Net::HTTP/#{args[0].method}", 
                                             "External/#{@address}/all",
                                             "External/allOther"]) do
          request_without_newrelic_trace(*args)
        end
      else
        self.class.trace_execution_scoped(["External/#{@address}/Net::HTTP/#{args[0].method}",
                                           "External/#{@address}/all",
                                           "External/allWeb"]) do
          request_without_newrelic_trace(*args)
        end
      end
    end
    alias request_without_newrelic_trace request
    alias request request_with_newrelic_trace
  end
end
