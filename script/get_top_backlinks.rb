
=begin

  Version 0.9.3

  Copyright (c) 2011, Majestic-12 Ltd
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
  3. Neither the name of the Majestic-12 Ltd nor the
  names of its contributors may be used to endorse or promote products
  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL Majestic-12 Ltd BE LIABLE FOR ANY
  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=end

# NOTE: The code below is specifically for the GetTopBackLinks API command
#       For other API commands, the arguments required may differ.
#       Please refer to the Majestic SEO Developer Wiki for more information
#       regarding other API commands and their arguments.


# add the majesticseo-external-rpc library to the search path
$: << File.expand_path(File.dirname(__FILE__));

require 'majesticseo-external-rpc/api_service'

endpoint = "http://enterprise.majesticseo.com/api_command";

puts "\n***********************************************************" +
  "*****************";

puts "\nEndpoint: #{endpoint}";

if("http://enterprise.majesticseo.com/api_command" == endpoint)
  puts "\nThis program is hard-wired to the Enterprise API.";

  puts "\nIf you do not have access to the Enterprise API, " +
    "change the endpoint to: \nhttp://developer.majesticseo.com/api_command.";
else
  puts "\nThis program is hard-wired to the Developer API " +
    "and hence the subset of data \nreturned will be substantially " +
    "smaller than that which will be returned from \neither the " +
    "Enterprise API or the Majestic SEO website.";

  puts "\nTo make this program use the Enterprise API, change " +
    "the endpoint to: \nhttp://enterprise.majesticseo.com/api_command.";
end

puts "\n***********************************************************" +
  "*****************";

puts "\n\nThis example program will return the top backlinks for any URL, domain " +
     "\nor subdomain." +
     "\n\nThe following must be provided in order to run this program: " +
     "\n1. API key, \n2. A URL, domain or subdomain to query" +
     "\n\nPlease enter your API key:\n";

api_key = gets.chomp;

puts "\nPlease enter a URL, domain or subdomain to query:\n";

item_to_query = gets.chomp;

# set up parameters
parameters = Hash.new;
parameters["MaxSourceURLs"] = "10";
parameters["URL"] = item_to_query;
parameters["GetUrlData"] = "1";
parameters["MaxSourceURLsPerRefDomain"] = "1";
parameters["datasource"] = "fresh";

api_service = ApiService.new(api_key, endpoint);
response = api_service.execute_command('GetTopBackLinks', parameters);

# check the response code
if(response.is_ok)
  # print the URL table
  results = response.table_for_name('URL');
  results.rows.each do |row|
    puts "\nURL: " + row['SourceURL']
    puts "ACRank: " + row['ACRank']
  end

  if("http://developer.majesticseo.com/api_command" == endpoint)
    puts "\n\n***********************************************************" +
      "*****************";

    puts "\nEndpoint: #{endpoint}";

    puts"\nThis program is hard-wired to the Developer API " +
      "and hence the subset of data \nreturned will be substantially " +
      "smaller than that which will be returned from \neither the " +
      "Enterprise API or the Majestic SEO website.";

    puts "\nTo make this program use the Enterprise API, change " +
      "the endpoint to: \nhttp://enterprise.majesticseo.com/api_command.";

    puts "\n***********************************************************" +
      "*****************";
  end
else
  puts "\nERROR MESSAGE:";
  puts response.error_message;

  puts "\n\n***********************************************************" +
    "*****************";

  puts "\nDebugging Info:";
  puts "\n  Endpoint: \t#{endpoint}";
  puts "  API Key: \t#{api_key}";

  if("http://enterprise.majesticseo.com/api_command" == endpoint)
    puts "\n  Is this API Key valid for this Endpoint?";

    puts "\n  This program is hard-wired to the Enterprise API.";

    puts "\n  If you do not have access to the Enterprise API, " +
      "change the endpoint to: \n  http://developer.majesticseo.com/api_command.";
  end

  puts "\n***********************************************************" +
    "*****************";
end