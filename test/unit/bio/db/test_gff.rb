#
# test/unit/bio/db/test_gff.rb - Unit test for Bio::GFF
#
# Copyright::   Copyright (C) 2005 Mitsuteru Nakao <n@bioruby.org>
# License::     The Ruby License
#
#  $Id: test_gff.rb,v 1.6 2007/04/05 23:35:43 trevor Exp $
#

require 'pathname'
libpath = Pathname.new(File.join(File.dirname(__FILE__), ['..'] * 4, 'lib')).cleanpath.to_s
$:.unshift(libpath) unless $:.include?(libpath)

require 'test/unit'
require 'bio/db/gff'

module Bio
  class TestGFF < Test::Unit::TestCase
    
    def setup
      data = <<END_OF_DATA
I	sgd	CEN	151453	151591	.	+	.	CEN "CEN1" ; Note "CEN1\; Chromosome I Centromere"
I	sgd	gene	147591	151163	.	-	.	Gene "TFC3" ; Note "transcription factor tau (TFIIIC) subunit 138"
I	sgd	gene	147591	151163	.	-	.	Gene "FUN24" ; Note "transcription factor tau (TFIIIC) subunit 138"
I	sgd	gene	147591	151163	.	-	.	Gene "TSV115" ; Note "transcription factor tau (TFIIIC) subunit 138"
I	sgd	ORF	147591	151163	.	-	.	ORF "YAL001C" ; Note "TFC3\; transcription factor tau (TFIIIC) subunit 138"
I	sgd	gene	143998	147528	.	+	.	Gene "VPS8" ; Note "Vps8p is a membrane-associated hydrophilic protein which contains a C-terminal cysteine-rich region that conforms to the H2 variant of the RING finger Zn2+ binding motif."
I	sgd	gene	143998	147528	.	+	.	Gene "FUN15" ; Note "Vps8p is a membrane-associated hydrophilic protein which contains a C-terminal cysteine-rich region that conforms to the H2 variant of the RING finger Zn2+ binding motif."
I	sgd	gene	143998	147528	.	+	.	Gene "VPT8" ; Note "Vps8p is a membrane-associated hydrophilic protein which contains a C-terminal cysteine-rich region that conforms to the H2 variant of the RING finger Zn2+ binding motif."
END_OF_DATA
      @obj = Bio::GFF.new(data)
    end

    def test_records
      assert_equal(8, @obj.records.size)
    end

    def test_record_class
      assert_equal(Bio::GFF::Record, @obj.records[0].class)
    end

  end # class TestGFF


  class TestGFF2 < Test::Unit::TestCase
    def test_version
      assert_equal(2, Bio::GFF::GFF2::VERSION)
    end
  end


  class TestGFF3 < Test::Unit::TestCase
    def test_version
      assert_equal(3, Bio::GFF::GFF3::VERSION)
    end
  end


  class TestGFFRecord < Test::Unit::TestCase
    
    def setup
      data =<<END_OF_DATA
I	sgd	gene	151453	151591	.	+	.	Gene "CEN1" ; Note "Chromosome I Centromere"
END_OF_DATA
      @obj = Bio::GFF::Record.new(data)
    end

    def test_seqname
      assert_equal('I', @obj.seqname)
    end

    def test_source
      assert_equal('sgd', @obj.source)
    end

    def test_feature
      assert_equal('gene', @obj.feature)
    end

    def test_start
      assert_equal('151453', @obj.start)
    end

    def test_end
      assert_equal('151591', @obj.end)
    end

    def test_score
      assert_equal('.', @obj.score)
    end

    def test_strand
      assert_equal('+', @obj.strand)
    end

    def test_frame
      assert_equal('.', @obj.frame)
    end

    def test_attributes
      at = {"Note"=>'"Chromosome I Centromere"', "Gene"=>'"CEN1"'}
      assert_equal(at, @obj.attributes)
    end

    def test_comments
      assert_equal(nil, @obj.comments)
    end

  end # class TestGFFRecord
  
  class TestGFFRecordConstruct < Test::Unit::TestCase

    def setup
      @obj = Bio::GFF.new
    end

    def test_add_seqname
      name = "test"
      record = Bio::GFF::Record.new("")
      record.seqname = name
      @obj.records << record
      assert_equal(name, @obj.records[0].seqname)
    end

  end # class TestGFFRecordConstruct
  
  class TestGFF3Record < Test::Unit::TestCase
    
    def setup
      data =<<END_OF_DATA
chrI	SGD	centromere	151467	151584	.	+	.	ID=CEN1;Name=CEN1;gene=CEN1;Alias=CEN1,test%3B0001;Note=Chromosome%20I%20centromere;dbxref=SGD:S000006463;Target=test%2002 123 456 -,test%2C03 159 314;memo%3Dtest%3Battr=99.9%25%09match
END_OF_DATA
      @obj = Bio::GFF::GFF3::Record.new(data)
    end

    def test_seqname
      assert_equal('chrI', @obj.seqname)
    end

    def test_source
      assert_equal('SGD', @obj.source)
    end

    def test_feature
      assert_equal('centromere', @obj.feature)
    end

    def test_start
      assert_equal(151467, @obj.start)
    end

    def test_end
      assert_equal(151584, @obj.end)
    end

    def test_score
      assert_equal(nil, @obj.score)
    end

    def test_strand
      assert_equal('+', @obj.strand)
    end

    def test_frame
      assert_equal(nil, @obj.frame)
    end

    def test_attributes
      attr = {
        'ID'     => 'CEN1',
        'Name'   => 'CEN1',
        'gene'   => 'CEN1',
        'Alias'  => [ 'CEN1', 'test;0001' ],
        'Note'   => 'Chromosome I centromere',
        'dbxref' => 'SGD:S000006463',
        'Target' =>
        [ Bio::GFF::GFF3::Record::Target.new('test 02', 123, 456, '-'),
          Bio::GFF::GFF3::Record::Target.new('test,03', 159, 314)
        ],
        'memo=test;attr' => "99.9%\tmatch",
      }
      assert_equal(attr, @obj.attributes)
    end

    def test_to_s
      str = <<END_OF_STR
chrI	SGD	centromere	151467	151584	.	+	.	ID=CEN1;Name=CEN1;Alias=CEN1,test%3B0001;Target=test%2002 123 456 -,test%2C03 159 314;Note=Chromosome I centromere;dbxref=SGD:S000006463;gene=CEN1;memo%3Dtest%3Battr=99.9%25%09match
END_OF_STR
      assert_equal(str, @obj.to_s)
    end
  end #class TestGFF3Record

  class TestGFF3RecordMisc < Test::Unit::TestCase
    def test_attributes_none
      # test blank with tab
      data =<<END_OF_DATA
I	sgd	gene	151453	151591	.	+	.	
END_OF_DATA
      obj = Bio::GFF::GFF3::Record.new(data)
      assert_equal({}, obj.attributes)
      
      # test blank with no tab at end
      data =<<END_OF_DATA
I	sgd	gene	151453	151591	.	+	.
END_OF_DATA
      obj = Bio::GFF::GFF3::Record.new(data)
      assert_equal({}, obj.attributes)
    end
    
    def test_attributes_one
      data =<<END_OF_DATA
I	sgd	gene	151453	151591	.	+	.	gene=CEN1
END_OF_DATA
      obj = Bio::GFF::GFF3::Record.new(data)
      at = {"gene"=>'CEN1'}
      assert_equal(at, obj.attributes)
    end
    
    def test_attributes_with_escaping
      data =<<END_OF_DATA
I	sgd	gene	151453	151591	.	+	.	gene="CEN1%3Boh";Note=Chromosome I Centromere
END_OF_DATA
      obj = Bio::GFF::GFF3::Record.new(data)
      at = { "Note" => 'Chromosome I Centromere', "gene" => '"CEN1;oh"' }
      assert_equal(at, obj.attributes)      
    end
    
    def test_attributes_three
      data =<<END_OF_DATA
I	sgd	gene	151453	151591	.	+	.	hi=Bye;gene=CEN1;Note=Chromosome I Centromere
END_OF_DATA
      obj = Bio::GFF::GFF3::Record.new(data)
      at = {"Note"=>'Chromosome I Centromere', "gene"=>'CEN1', 'hi'=>'Bye'}
      assert_equal(at, obj.attributes)      
    end
  end #class TestGFF3RecordMisc

  class TestGFF3RecordEscape < Test::Unit::TestCase
    def setup
      @obj = Object.new.extend(Bio::GFF::GFF3::Record::Escape)
      @str = "A>B\tC=100%;d=e,f,g"
    end

    def test_escape
      str = @str
      assert_equal('A>B%09C=100%25;d=e,f,g',
                   @obj.instance_eval { escape(str) })
    end

    def test_escape_attribute
      str = @str
      assert_equal('A>B%09C%3D100%25%3Bd%3De%2Cf%2Cg',
                   @obj.instance_eval { escape_attribute(str) })
    end

    def test_escape_seqid
      str = @str
      assert_equal('A%3EB%09C%3D100%25%3Bd%3De%2Cf%2Cg',
                   @obj.instance_eval { escape_seqid(str) })
    end

    def test_unescape
      escaped_str = 'A%3EB%09C%3D100%25%3Bd%3De%2Cf%2Cg'
      assert_equal(@str,
                   @obj.instance_eval {
                     unescape(escaped_str) })
    end
  end #class TestGFF3RecordEscape

  class TestGFF3RecordTarget < Test::Unit::TestCase

    def setup
      @target =
        [ Bio::GFF::GFF3::Record::Target.new('ABCD1234', 123, 456, '+'),
          Bio::GFF::GFF3::Record::Target.new(">X Y=Z;P%,Q\tR", 78, 90),
          Bio::GFF::GFF3::Record::Target.new(nil, nil, nil),
        ]
    end

    def test_parse
      strings = 
        [ 'ABCD1234 123 456 +',
          '%3EX%20Y%3DZ%3BP%25%2CQ%09R 78 90',
          ''
        ]
      @target.each do |target|
        str = strings.shift
        assert_equal(target, Bio::GFF::GFF3::Record::Target.parse(str))
      end
    end

    def test_target_id
      assert_equal('ABCD1234', @target[0].target_id)
      assert_equal(">X Y=Z;P%,Q\tR", @target[1].target_id)
      assert_equal(nil, @target[2].target_id)
    end

    def test_start
      assert_equal(123, @target[0].start)
      assert_equal(78, @target[1].start)
      assert_nil(@target[2].start)
    end

    def test_end
      assert_equal(456, @target[0].end)
      assert_equal(90, @target[1].end)
      assert_nil(@target[2].end)
    end

    def test_strand
      assert_equal('+', @target[0].strand)
      assert_nil(@target[1].strand)
      assert_nil(@target[2].strand)
    end

    def test_to_s
      assert_equal('ABCD1234 123 456 +', @target[0].to_s)
      assert_equal('%3EX%20Y%3DZ%3BP%25%2CQ%09R 78 90', @target[1].to_s)
      assert_equal('. . .', @target[2].to_s)
    end

  end #class TestGFF3RecordTarget

end #module Bio


