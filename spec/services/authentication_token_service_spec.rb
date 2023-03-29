require 'rails_helper'

describe AuthenticationTokenService do
    describe '.call' do
        # assign hardcoded user_id as arg
        let(:token) { described_class.call(1) }

        it 'it returns an authentication token' do    
            decoded_token = JWT.decode(
                token,
                described_class::HMAC_SECRET,
                true,
                { algorithm: described_class::ALG_TYPE }
            ) 

            expect(decoded_token).to eq(
                [
                    {'user_id' => 1},
                    {'alg' => 'HS256'}
                ])
        end
    end
end