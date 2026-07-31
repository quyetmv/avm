#!/bin/bash
set -e

echo "Building Docker image for testing..."
docker build -t ansible-version-test -f Dockerfile.test .

echo "----------------------------------------"
echo "Running tests in container..."

# Test if avm correctly invokes the versions
for v in 5 6 7 8 9 10; do
    echo "Testing avm $v..."
    
    # We pass an exit command to the subshell because avm $v starts an interactive session.
    # The output should display the success message.
    output=$(docker run --rm -i ansible-version-test bash -c "avm $v" <<EOF
echo "Ansible version check in subshell:"
ansible --version | head -n 1
exit
EOF
    )
    
    echo "$output"
    
    # Check if the output contains the success message
    if echo "$output" | grep -q "Successfully switched to Ansible $v environment"; then
        echo "✅ avm $v works correctly."
    else
        echo "❌ avm $v failed."
        exit 1
    fi
done

echo "----------------------------------------"
echo "All tests passed successfully! 🚀"
