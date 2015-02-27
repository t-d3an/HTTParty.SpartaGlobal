require 'spec_helper' 
  require 'httparty' 
    require 'yaml'
 
describe "ToDo" do
    
  let(:r) {r = YAML.load(File.open('todos.yml'))} 
    let(:data) {data = r["todo"]} 

#Get
it "Should Get collection" do
  expect((HTTParty.get "http://lacedeamon.spartaglobal.com/todos").code).to eq(200)
end 

#Post
it "Should create a Post" do  
  rpost = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: data[0] 
    expect(rpost.code).to eq(201)
end 
 
it "Should not Post with the wrong format" do 
  expect((HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: data[1]).code).to eq(500) 
end  

it "Should not Post with missing parameters" do 
  expect((HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: data[2]).code).to eq(422) 
end 

#Modify
it "Should be able to modify content using Patch" do 
  rpost = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: data[0] 
  
    rpatch = HTTParty.patch "http://lacedeamon.spartaglobal.com/todos/#{id}", query: {title: 'AB'} 
       expect(rpatch.code).to eq(200) 
         expect(rpatch["title"]).to eq('AB')
end 

it "Should not be able to modify specific content using Put" do 
  rpost = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: data[0] 

    rput = HTTParty.put "http://lacedeamon.spartaglobal.com/todos/#{id}", query: {title: 'ABC'} 
      expect(rput.code).to eq(422) 
end 

it "Should be able to modify content using Put with all parameters present" do 
  rpost = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: data[0]
    
    rput = HTTParty.put "http://lacedeamon.spartaglobal.com/todos/#{id}", query: {title: 'ABC', due: '27/02/2015'} 
      expect(rput.code).to eq(200) 
        expect(rput["title"]).to eq('ABC')
          expect(rput["due"]).to eq('27/02/2015') 
end

#Delete
it "Should delete a Post" do 
  rpost = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: data[0] 
    
    expect((HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{id}").code).to eq(204) 
end 

it "Should not delete a collection" do 
  expect((HTTParty.delete "http://lacedeamon.spartaglobal.com/todos").code).to eq(405) 
end 

end