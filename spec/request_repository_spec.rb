require 'request'
require 'request_repository'

RSpec.describe RequestRepository do

    def reset_request_table
        seed_sql = File.read('spec/seeds.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
        connection.exec(seed_sql)
    end

    before(:each) do
        reset_request_table
    end

    it 'Gets all requests' do
        repo = RequestRepository.new

        requests = repo.all
        
        expect(requests.length).to eq(2)
        
        expect(requests[0].id).to eq(1)
        expect(requests[0].space_id).to eq(1)
        expect(requests[0].owner_user_id).to eq(2)
        expect(requests[0].requester_user_id).to eq(1)
        expect(requests[0].date).to eq('2022-09-24')
        expect(requests[0].confirmed).to eq(false)
        
        expect(requests[1].id).to eq(2)
        expect(requests[1].space_id).to eq(2)
        expect(requests[1].owner_user_id).to eq(1)
        expect(requests[1].requester_user_id).to eq(2)
        expect(requests[1].date).to eq('2022-12-26')
        expect(requests[1].confirmed).to eq(false)
    end

    # 2
    # Get a single request
    it 'Gets a single request' do
        repo = RequestRepository.new
        request = repo.find(1)
        expect(request.id).to eq(1)
        expect(request.space_id).to eq(1)
        expect(request.owner_user_id).to eq(2)
        expect(request.requester_user_id).to eq(1)
        expect(request.date).to eq('2022-09-24')
        expect(request.confirmed).to eq(false)
    end

    # 3
    # create a request
    it 'creates a request' do
        repo = RequestRepository.new

        new_request = Request.new
        new_request.space_id = 1
        new_request.owner_user_id = 2
        new_request.requester_user_id = 1
        new_request.date = '2022-09-25'
        new_request.confirmed = false

        repo.create(new_request)

        all_requests = repo.all
        expect(all_requests.last.date).to eq '2022-09-25'
    end

    # 4
    # confirm a request
    it 'confirms a request' do
        repo = RequestRepository.new

        request1 = repo.find(1)
        repo.confirm(request1)

        updated_request1 = repo.find(1)

        expect(updated_request1.confirmed).to eq true
    end

    # 5
    # delete a request
    it 'deletes a request' do
        repo = RequestRepository.new

        expect(repo.all.length).to eq 2
        repo.delete(1)
        expect(repo.all.length).to eq 1
    end

    # 6
    # filter a request by owner user id
    it 'filter a request by owner user id' do
        repo = RequestRepository.new

        requests_of_owner2 = repo.filter_by_owner_user_id(2)

        expect(requests_of_owner2[0].id).to eq 1
        expect(requests_of_owner2[0].space_id).to eq 1
        expect(requests_of_owner2[0].owner_user_id).to eq 2
        expect(requests_of_owner2[0].requester_user_id).to eq 1
        expect(requests_of_owner2[0].date).to eq '2022-09-24'
        expect(requests_of_owner2[0].confirmed).to eq false
    end

    # 7
    # filter a request by requester user id
    it 'filter a request by requester user id' do
        repo = RequestRepository.new
        requests_of_requester1 = repo.filter_by_requester_user_id(1)
        expect(requests_of_requester1[0].id).to eq 1
        expect(requests_of_requester1[0].space_id).to eq 1
        expect(requests_of_requester1[0].owner_user_id).to eq 2
        expect(requests_of_requester1[0].requester_user_id).to eq 1
        expect(requests_of_requester1[0].date).to eq '2022-09-24'
        expect(requests_of_requester1[0].confirmed).to eq false
    end
end