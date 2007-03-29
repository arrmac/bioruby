#
# test/functional/bio/io/test_ensembl.rb - Functional test for Bio::Ensembl
#
# Copyright::   Copyright (C) 2007
#               Mitsuteru C. Nakao <n@bioruby.org>
# License::     Ruby's
#
#  $Id: test_ensembl.rb,v 1.1 2007/03/29 05:24:59 nakao Exp $
#

require 'pathname'
libpath = Pathname.new(File.join(File.dirname(__FILE__), ['..'] * 4, 'lib')).cleanpath.to_s
$:.unshift(libpath) unless $:.include?(libpath)


require 'test/unit'
require 'bio/io/ensembl'

module Bio

class FuncTestEnsembl < Test::Unit::TestCase
  def setup
    @serv = Bio::Ensembl.new('Homo_sapiens')
  end
  
  def test_class
    assert_equal(Bio::Ensembl, @serv.class)
  end
end

class FuncTestEnsemblHuman < Test::Unit::TestCase
  def setup
    @serv = Bio::Ensembl.human
  end 

  def test_organism
    assert_equal("Homo_sapiens", @serv.organism)
  end
  
  def test_server
    assert_equal("http://www.ensembl.org", @serv.server)
  end

  def test_fna_exportview
    seq = ">4 dna:chromosome chromosome:NCBI36:4:1149206:1149209:1\nGAGA\n"
    fna = @serv.exportview(4, 1149206, 1149209)
    assert_equal(seq, fna)
  end

  def test_fna_exportview_with_named_args
    seq = ">4 dna:chromosome chromosome:NCBI36:4:1149206:1149209:1\nGAGA\n"
    fna = @serv.exportview(:seq_region_name => 4,
                           :anchor1 => 1149206,
                           :anchor2 => 1149209)
    assert_equal(seq, fna)
  end 

   def test_gff_exportview
     line = "chromosome:NCBI36:4:1149206:1149209:1\tEnsembl\tGene\t-839\t2747\t.\t+\t.\tgene_id=ENSG00000206158; transcript_id=ENST00000382964; exon_id=ENSE00001494097; gene_type=KNOWN_protein_coding\n"
     gff = @serv.exportview(4, 1149206, 1149209, ['gene'])
     assert_equal(line, gff)
   end

   def test_gff_exportview_with_named_args
     line = "chromosome:NCBI36:4:1149206:1149209:1\tEnsembl\tGene\t-839\t2747\t.\t+\t.\tgene_id=ENSG00000206158; transcript_id=ENST00000382964; exon_id=ENSE00001494097; gene_type=KNOWN_protein_coding\n"
     gff = @serv.exportview(:seq_region_name => 4,
                            :anchor1 => 1149206,
                            :anchor2 => 1149209, 
                            :options => ['gene'])
     assert_equal(line, gff)
   end 

end

end # module Bio
