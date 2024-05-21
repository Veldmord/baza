namespace :my do
    task uncod: :environment do
        require 'iconv'

        text = '╨в╨╡╨┐╨╡╤А╤М ╤В╨╛╤З╨╜╨╛ ╨▓╤Б╨╡ ╨┐╨╛╨╗╤Г╤З╨╕╤В╤Б╤П'

        #text1 = text.encode('Windows-1251')

        iconv = Iconv.new('UTF-8', 'Windows-1251') # или 'Windows-1251'
        text = iconv.iconv(text)

        puts text
       # puts text1
      end
end