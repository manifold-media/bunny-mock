describe BunnyMock::Channel do

	before do
		@session = BunnyMock::Session.new
		@channel = @session.create_channel 1
	end

	context '::new' do

		before do
			@channel = BunnyMock::Channel.new @session, 1
		end

		it 'should store connection' do

			expect(@channel.connection).to eq(@session)
		end

		it 'should store channel identifier' do

			expect(@channel.id).to eq(1)
		end

		it 'should set status to opening' do

			expect(@channel.status).to eq(:opening)
		end
	end

	context '#open' do

		it 'should set status to open' do

			expect(@channel.open.status).to eq(:open)
		end
	end

	context '#close' do

		it 'should set status to open' do

			@channel.open

			expect(@channel.close.status).to eq(:closed)
		end
	end

	context '#open?' do

		it 'should return true if status is open' do

			expect(@channel.open?).to be_truthy
		end

		it 'should return false otherwise' do

			# opening
			expect(BunnyMock::Channel.new.open?).to be_falsey

			# closed
			expect(@channel.close.open?).to be_falsey
		end
	end

	context '#closed?' do

		it 'should return true if status is closed' do

			expect(@channel.close.closed?).to be_truthy
		end

		it 'should return false otherwise' do

			# opening
			expect(BunnyMock::Channel.new.closed?).to be_falsey

			# open
			expect(@channel.closed?).to be_falsey
		end
	end

	context '#exchange' do

		it 'should declare a new exchange' do

			xchg = @channel.exchange 'testing.xchg', type: :fanout

			expect(xchg.class).to eq(BunnyMock::Exchanges::Fanout)
		end

		it 'should return a cached exchange with the same name' do

			xchg = @channel.exchange 'testing.xchg', type: :fanout

			expect(@channel.exchange('testing.xchg', type: :fanout)).to eq(xchg)
		end

		it 'should register the exchange in cache' do

			xchg = @channel.exchange 'testing.xchg', type: :fanout

			expect(@channel.exchanges['testing.xchg']).to eq(xchg)
		end
	end

	context '#direct' do

		it 'should declare a new direct exchange' do

			expect(@channel.direct('testing.xchg').class).to eq(BunnyMock::Exchanges::Direct)
		end
	end

	context '#topic' do

		it 'should declare a new topic exchange' do

			expect(@channel.topic('testing.xchg').class).to eq(BunnyMock::Exchanges::Topic)
		end
	end

	context '#fanout' do

		it 'should declare a new fanout exchange' do

			expect(@channel.fanout('testing.xchg').class).to eq(BunnyMock::Exchanges::Fanout)
		end
	end

	context '#header' do

		it 'should declare a new headers exchange' do

			expect(@channel.header('testing.xchg').class).to eq(BunnyMock::Exchanges::Header)
		end
	end

	context '#default_exchange' do

		it 'should return a nameless direct exchange' do

			xchg = @channel.default_exchange

			expect(xchg.class).to eq(BunnyMock::Exchanges::Direct)
			expect(xchg.name).to eq('')
		end
	end

	context '#queue' do

		it 'should declare a new queue' do

			q = @channel.queue 'testing.q'

			expect(q.class).to eq(BunnyMock::Queue)
		end

		it 'should return a cached queue with the same name' do

			q = @channel.queue 'testing.q'

			expect(@channel.queue('testing.q')).to eq(q)
		end

		it 'should register the queue in cache' do

			q = @channel.queue 'testing.q'

			expect(@channel.queues['testing.q']).to eq(q)
		end
	end

	context '#temporary_queue' do

		it 'should declare a nameless queue' do

			expect(@channel.temporary_queue.class).to eq(BunnyMock::Queue)
		end
	end
end