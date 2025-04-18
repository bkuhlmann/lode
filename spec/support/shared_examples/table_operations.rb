# frozen_string_literal: true

RSpec.shared_examples "table operations" do
  describe "#find" do
    it "answers record" do
      store.transaction do
        table.upsert record
        expect(table.find(1)).to be_success(record)
      end
    end

    it "answers failure when record is not found" do
      store.transaction { expect(table.find(13)).to be_failure("Unable to find id: 13.") }
    end
  end

  describe "#create" do
    it "creates record" do
      store.transaction do
        table.create record
        expect(table.all).to be_success([record])
      end
    end

    it "answers created record" do
      store.transaction { expect(table.create(record)).to be_success(record) }
    end

    it "answers failure when when record exists" do
      store.transaction do
        table.create record
        expect(table.create(record)).to be_failure("Record exists for id: 1.")
      end
    end
  end

  describe "#upsert" do
    it "creates new record for record" do
      store.transaction do
        table.upsert record
        expect(table.all).to be_success([record])
      end
    end

    it "creates new record for hash" do
      store.transaction do
        table.upsert record.to_h
        expect(table.all).to be_success([record])
      end
    end

    it "answers created record" do
      store.transaction { expect(table.upsert(record)).to be_success(record) }
    end
  end

  describe "#delete" do
    it "deletes existing record" do
      store.transaction do
        table.upsert record
        table.delete 1

        expect(table.all).to be_success([])
      end
    end

    it "answers deleted record" do
      store.transaction do
        table.upsert record
        expect(table.delete(1)).to be_success(record)
      end
    end

    it "doesn't delete invalid record" do
      store.transaction do
        table.upsert record
        table.delete 13

        expect(table.all).to be_success([record])
      end
    end

    it "answers failure when record doesn't exist" do
      store.transaction { expect(table.delete(13)).to be_failure("Unable to find id: 13.") }
    end
  end
end
