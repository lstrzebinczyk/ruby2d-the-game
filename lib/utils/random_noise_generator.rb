class RandomNoiseGenerator
  def initialize
    @perlin ||= Perlin::Noise.new(2)
    @contrast ||= Perlin::Curve.contrast(Perlin::Curve::CUBIC, 4)
    @divider ||= 15
  end

  def get(x, y)
    n = @perlin[x.to_f / 30, y.to_f / 30]
    n = @contrast.call(n).to_f / @divider
    n
  end
end
