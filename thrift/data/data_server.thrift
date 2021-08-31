namespace * astraea.thrift.data

include "data/language.thrift"
include "error.thrift"

service DataService {
  // Language
  list<language.Language> language_index() throws (1: error.Error e)
  language.Language language_show(1: string id) throws (1: error.Error e)
  void language_create(1: language.Language language) throws (1: error.Error e)
  void language_update(1: language.Language language) throws (1: error.Error e)
  void language_delete(1: string id) throws (1: error.Error e)
  language.Language get_language_script(1: string id) throws (1: error.Error e)
}
