class Spaces < Cuba

  define do
    on ':space' do |space|
      on 'apps' do
        on get do
          res.write view('apps/index', :space => space)
        end
      end
    end
  end

end
