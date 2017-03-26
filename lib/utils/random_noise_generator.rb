class RandomNoiseGenerator
  def initialize
    @perlin ||= Perlin::Noise.new(2)
    @contrast ||= Perlin::Curve.contrast(Perlin::Curve::CUBIC, 4)
    @divider ||= 5 + rand / 2
  end

  def get(x, y)
    n = @perlin[x.to_f / 30, y.to_f / 30]
    n = @contrast.call(n) / @divider
    n
  end
end
