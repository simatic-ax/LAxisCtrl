USING AxUnit.Assert;

NAMESPACE Simatic.Ax.LAxisCtrl.Tests
    {TestFixture}
    CLASS MyTestFixture
        {Test}
        METHOD PUBLIC MyTestMethod
            Equal(actual := TRUE, expected := TRUE);
        END_METHOD
    END_CLASS
END_NAMESPACE
