class RandomNoiseGenerator
  def initialize
    @perlin ||= Perlin::Noise.new(2)
    @contrast ||= Perlin::Curve.contrast(Perlin::Curve::CUBIC, 4)
    @divider ||= 12.0
  end

  def get(x, y)
    n = @perlin[x * 0.033, y * 0.033]
    n = @contrast.call(n) / @divider
    n
  end
end
