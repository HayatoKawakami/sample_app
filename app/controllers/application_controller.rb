class ApplicationController < ActionController::Base
    include SessionsHelper
    def hello
        render html: "これはサンプルアプリのテストデプロイ用更新です"
    end
end
