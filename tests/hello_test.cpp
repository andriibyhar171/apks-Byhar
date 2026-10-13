#include <gtest/gtest.h>

#include "hello.h"

TEST(HelloTest, BasicAddition) {
  EXPECT_EQ(2 + 2, 4);
}

TEST(HelloTest, MessageIsCorrect) {
  EXPECT_EQ(hello::message(), "Hello, World!");
}

