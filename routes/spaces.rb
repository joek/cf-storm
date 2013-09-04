class Spaces < Cuba

  define do
    on get, ':space/apps' do |space|
      res.write view('apps/index', :space => space)
    end
  end

end
