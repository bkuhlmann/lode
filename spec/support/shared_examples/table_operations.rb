# frozen_string_literal: true

RSpec.shared_examples "with table operations" do
  include Dry::Monads[:result]

  describe "#find" do
    it "answers record (value object) if found" do
      store.transaction do
        table.upsert record
        expect(table.find(1)).to eq(Success(record))
      end
    end

    it "answers failure when record (value object) is not found" do
      store.transaction { expect(table.find(13)).to eq(Failure("Unable to find id: 13.")) }
    end
  end

  describe "#upsert" do
    it "creates new record for record" do
      store.transaction do
        table.upsert record
        expect(table.all).to eq(Success([record]))
      end
    end

    it "creates new record for hash" do
      store.transaction do
        table.upsert record.to_h
        expect(table.all).to eq(Success([record]))
      end
    end

    it "answers created record" do
      store.transaction { expect(table.upsert(record)).to eq(Success(record)) }
    end
  end

  describe "#delete" do
    it "deletes existing record" do
      store.transaction do
        table.upsert record
        table.delete 1

        expect(table.all).to eq(Success([]))
      end
    end

    it "answers deleted record" do
      store.transaction do
        table.upsert record
        expect(table.delete(1)).to eq(Success(record))
      end
    end

    it "doesn't delete invalid record" do
      store.transaction do
        table.upsert record
        table.delete 13

        expect(table.all).to eq(Success([record]))
      end
    end

    it "answers nil when record doesn't exist" do
      store.transaction { expect(table.delete(13)).to eq(Failure("Unable to find id: 13.")) }
    end
  end
end
