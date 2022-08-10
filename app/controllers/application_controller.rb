class ApplicationController < ActionController::Base
    def hello
        render html: "これはサンプルアプリのテストデプロイ用更新です"
    end
end
