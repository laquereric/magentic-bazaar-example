module Admin
  class SystemStatusesController < BaseController
    def show
      config = MagenticBazaar.configuration

      @directory_stats = {
        ingest: dir_stats(config.ingest_dir),
        ingested: dir_stats(config.ingested_dir),
        uml: dir_stats(config.uml_dir),
        skills: dir_stats(config.skills_dir),
        human: dir_stats(config.human_dir)
      }

      @db_stats = {
        documents: MagenticBazaar::Document.count,
        ingestions: MagenticBazaar::Ingestion.count,
        skills: MagenticBazaar::Skill.count,
        uml_diagrams: MagenticBazaar::UmlDiagram.count,
        users: User.count,
        sessions: Session.count
      }

      @queue_stats = {
        pending: SolidQueue::Job.where(finished_at: nil).count,
        completed: SolidQueue::Job.where.not(finished_at: nil).count
      }
    rescue => e
      @queue_stats = { error: e.message }
    end

    private
      def dir_stats(path)
        return { exists: false, files: 0, size: "0 B" } unless File.directory?(path)

        files = Dir.glob(File.join(path, "*"))
        total_size = files.sum { |f| File.file?(f) ? File.size(f) : 0 }

        { exists: true, files: files.count, size: human_size(total_size) }
      end

      def human_size(bytes)
        return "0 B" if bytes == 0
        units = %w[B KB MB GB]
        exp = (Math.log(bytes) / Math.log(1024)).to_i
        exp = units.length - 1 if exp >= units.length
        "%.1f %s" % [ bytes.to_f / (1024**exp), units[exp] ]
      end
  end
end
