import io.quarkus.qute.Template
import io.quarkus.qute.TemplateInstance
import jakarta.ws.rs.DefaultValue
import jakarta.ws.rs.GET
import jakarta.ws.rs.Path
import jakarta.ws.rs.Produces
import jakarta.ws.rs.QueryParam
import jakarta.ws.rs.core.MediaType

@Path("/demo")
class DemoController(
    val demo: Template
) {
    @GET
    @Produces(MediaType.TEXT_HTML)
    fun index(@QueryParam("name") @DefaultValue("World") name: String): TemplateInstance =
        demo.data("name", name)

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/json")
fun json(@QueryParam("name") @DefaultValue("World") name: String): DemoModel =
        DemoModel(name)
}