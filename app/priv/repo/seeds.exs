alias FlamingoSchemas.Collection
alias FlamingoSchemas.Block
alias FlamingoSchemas.Page

alias Flamingo.Infra.Repo

collection =
  Repo.insert!(%Collection{
    name: "Posts",
    description: "This is a collection of posts.",
    template: "<h1>{{ title }}</h1><p>{{ content }}</p>",
    blocks: [
      %Block{label: "Title", name: "title", type: :text},
      %Block{label: "Content", name: "content", type: :text}
    ]
  })

for i <- 1..10 do
  Repo.insert!(%Page{
    handle: "post-#{i}",
    collection: collection,
    blocks: [
      %Block{label: "Title", name: "title", type: :text, value: "Post #{i}"},
      %Block{
        label: "Content",
        name: "content",
        type: :text,
        value: "This is the content of post #{i}."
      }
    ]
  })
end
