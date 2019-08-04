require 'rails_helper'

RSpec.describe QuestionSubscriptionJob, type: :job do
  let(:service) { double('Service::QuestionSubscription') }
  let(:answer) { create(:answer) }

  before do
    allow(Services::QuestionSubscription).to receive(:new).and_return(service)
  end

  it 'calls Service::QuestionSubscription#send_subscription' do
    expect(service).to receive(:send_subscription).with(answer)

    QuestionSubscriptionJob.perform_now(answer)
  end
end
