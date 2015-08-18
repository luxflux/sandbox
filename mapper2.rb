require 'rom-mapper'
require 'pp'

input = {
  a: {
    b: {},
    c: {
      d: [
        {
          something: {
            key: 'value',
          },
          yay: 1
        },
        {},
        {}
      ]
    }
  }
}

class Preprocessor < ROM::Mapper
  reject_keys true

  step do
    embedded :a, type: :hash do
      embedded :c, type: :hash do
        embedded :d, type: :array do
          attribute :something
          # embedded :something, type: :hash do
          #   attribute(:key) { '' }
          # end
        end
      end
    end
  end

  step do
    unwrap :a do
      attribute :c
    end
  end

  step do
    unwrap :c do
      attribute :items, from: :d
    end
  end

  step do
    ungroup :items do
      attribute :something do |value|
        value.nil? ? {} : value
      end
    end
  end
# end

# class Mapper < ROM::Mapper
  step do
    unwrap :something do
      attribute :key
    end
  end
end

val = Preprocessor.build.call([input])
pp val
# val.reject! { |v| !v[:something] }
# pp val
# pp Mapper.build.call(val)


class Yolo < ROM::Mapper
  attribute :id

  embedded :details, type: :hash do
    attribute :name
  end
end

data = [ { id: 1, details: { name: 'bruce' } }, {} ]

pp Yolo.build.call(data)
