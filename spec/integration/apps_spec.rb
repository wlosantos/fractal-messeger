require "swagger_helper"

RSpec.describe "Apps API" do
  let(:admin) { create(:user, :admin) }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: admin.email, fractal_id: admin.fractal_id }) }
  let(:headers) do
    {
      "Accept" => "application/vnd.fractal-messeger.v1",
      "Content-Type" => Mime[:json].to_s,
      "Authorization" => "Bearer #{token}"
    }
  end

  # list all apps
  path "/api/apps" do
    get "List all apps" do
      tags "Apps"
      security [Bearer: {}]

      produces "application/json"

      response "200", "Index app" do
        schema type: :object,
                properties: {
                  id: { type: :integer, example: 1 },
                  name: { type: :string, example: "Bertoni Med" },
                  app_id: { type: :integer, example: 30 },
                  contacts: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer, example: 1 },
                        name: { type: :string, example: "Renato Freire" },
                        email: { type: :string, example: "renato@freire.com" },
                        fractalId: { type: :string, example: "10006" }
                      },
                      required: %w[id name email fractalId]
                    }
                  }
                },
                required: %w[id name app_id contacts]

        let(:Authorization) { "Bearer #{token}" }
        before { create(:app) }
        run_test!
      end

      response "401", "Unauthorized" do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  # show app
  path "/api/apps/{id}" do
    get "Show app" do
      tags "Apps"
      security [Bearer: {}]

      produces "application/json"
      parameter name: :id, in: :path, type: :integer, required: true, description: "app id"

      response "200", "app found" do
        schema type: :object,
                properties: {
                  id: { type: :integer, example: 1 },
                  name: { type: :string, example: "Bertoni Med" },
                  app_id: { type: :integer, example: 30 },
                  contacts: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer, example: 1 },
                        name: { type: :string, example: "Renato Freire" },
                        email: { type: :string, example: "renato@freire.com" },
                        fractalId: { type: :string, example: "10006" }
                      },
                      required: %w[id name email fractalId]
                    }
                  },
                  rooms: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer, example: 1 },
                        name: { type: :string, example: "Room 1" },
                        kind: { type: :string, example: "groups" },
                        createBy: {
                          type: :object,
                          properties: {
                            id: { type: :integer, example: 1 },
                            name: { type: :string, example: "Renato Freire" },
                            email: { type: :string, example: "renato@email.com" },
                            permitions: { type: :array, items: { type: :string, example: "admin" } }
                          },
                          required: %w[id name email permitions]
                        }
                      },
                      required: %w[id name kind createBy]
                    }
                  }
                },
                required: %w[id name app_id contacts rooms]

        let(:Authorization) { "Bearer #{token}" }
        let(:id) { create(:app).id }
        run_test!
      end

      response "404", "app not found" do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { 0 }
        run_test!
      end

      response "401", "Unauthorized" do
        let(:Authorization) { nil }
        let(:id) { create(:app).id }
        run_test!
      end
    end
  end
end
