Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C346BAB14
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Mar 2023 09:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjCOIt6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Mar 2023 04:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbjCOIt5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Mar 2023 04:49:57 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECD97EDD
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 01:49:53 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c10so11209286pfv.13
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 01:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1678870192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YkxChdLDa4UFijk1Jheg8QY/La3zPetPy6md4h64POE=;
        b=QjRMzeMPM7bEXlB6ydwS837/NFUyQ8FTlay7FyNeoNs0VDwU6tSXowOh5PEijcS3y8
         sD6nxAC6h4K1cRCQD9qu0IFALoN8EolNk7Bid2nRlhUXSKUTeDvUpAvWMnwt+HPHUQx/
         KyyxJcLdPcRikCzCFdYvFjT+Mqx43i8pHeTDS+TQTsjpdDOaSGXHR1WhZ00ymwBzz/6L
         oUBDFOeHVrVNwCUzNaMl/ntSSHv31y6BC2N0XzgLSBSKpat6+edLAyQmzHqhhsxZ7a1M
         lj1RUSkyW5Ia0Sp/kwGQHE1me5OM6WQIgiCDHeaI+wyfJ3J//4uGOBLUlhHOul1FoJei
         V5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678870192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YkxChdLDa4UFijk1Jheg8QY/La3zPetPy6md4h64POE=;
        b=nqvbLJi9atnQzr76i1yBleWu2yWabO8bw/k9G4DHrdFSNkwZJxPYyBipM2iwFBC5nZ
         1QHWIsOryhV3s24DkoAHe0t3vJIGyu4fAdjsHc3wkhxDTA+ZD3nUSBhpzr8E4I2JGUzz
         m6AcdgNSXuQTvT82cLWm1VyQ1eDzKm2+8L4RIa/eGMWcmDQfvI5NBsDl8i2VZjFIjWB0
         YaFkmEsVHN284zl4/0mLNevoSMJUyQ4vgnrgD2dCiGQHmvWcXmk7RDi3HR3wI2hqfL2A
         xJOjWLFViAdYZu9ej/jDRksXpOpQ/n9QkhqEItxHYgb9zsnNEhJSaBGv6DNXUFN91nIk
         CFuw==
X-Gm-Message-State: AO0yUKV84WozbSKuKn+4tb4XR0hbWzTCxGSgMEjgPUqjLAtidU97fXay
        e7VIv4M63txrQlBPBJ4yqa7LWw==
X-Google-Smtp-Source: AK7set+PAG3sniqSn+uEJTES+NuHK2ZCXd+V9ulDUeNZd08I0VS+GAnsdTPkVoBU/h/tKlRjkhWWSg==
X-Received: by 2002:aa7:8ec1:0:b0:625:8217:15b9 with SMTP id b1-20020aa78ec1000000b00625821715b9mr3081112pfr.2.1678870191951;
        Wed, 15 Mar 2023 01:49:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id i17-20020aa787d1000000b0058d9058fe8asm2966024pfo.103.2023.03.15.01.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 01:49:51 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pcMpQ-008zeS-2N; Wed, 15 Mar 2023 19:49:48 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pcMpQ-00Ag6L-0D;
        Wed, 15 Mar 2023 19:49:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     linux-mm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        yebin10@huawei.com
Subject: [PATCH 1/4] cpumask: introduce for_each_cpu_or
Date:   Wed, 15 Mar 2023 19:49:35 +1100
Message-Id: <20230315084938.2544737-2-david@fromorbit.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315084938.2544737-1-david@fromorbit.com>
References: <20230315084938.2544737-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Equivalent of for_each_cpu_and, except it ORs the two masks together
so it iterates all the CPUs present in either mask.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/cpumask.h | 17 +++++++++++++++++
 include/linux/find.h    | 37 +++++++++++++++++++++++++++++++++++++
 lib/find_bit.c          |  9 +++++++++
 3 files changed, 63 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index d4901ca8883c..ca736b05ec7b 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -350,6 +350,23 @@ unsigned int __pure cpumask_next_wrap(int n, const struct cpumask *mask, int sta
 #define for_each_cpu_andnot(cpu, mask1, mask2)				\
 	for_each_andnot_bit(cpu, cpumask_bits(mask1), cpumask_bits(mask2), small_cpumask_bits)
 
+/**
+ * for_each_cpu_or - iterate over every cpu present in either mask
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask1: the first cpumask pointer
+ * @mask2: the second cpumask pointer
+ *
+ * This saves a temporary CPU mask in many places.  It is equivalent to:
+ *	struct cpumask tmp;
+ *	cpumask_or(&tmp, &mask1, &mask2);
+ *	for_each_cpu(cpu, &tmp)
+ *		...
+ *
+ * After the loop, cpu is >= nr_cpu_ids.
+ */
+#define for_each_cpu_or(cpu, mask1, mask2)				\
+	for_each_or_bit(cpu, cpumask_bits(mask1), cpumask_bits(mask2), small_cpumask_bits)
+
 /**
  * cpumask_any_but - return a "random" in a cpumask, but not this one.
  * @mask: the cpumask to search
diff --git a/include/linux/find.h b/include/linux/find.h
index 4647864a5ffd..5e4f39ef2e72 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -14,6 +14,8 @@ unsigned long _find_next_and_bit(const unsigned long *addr1, const unsigned long
 					unsigned long nbits, unsigned long start);
 unsigned long _find_next_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long nbits, unsigned long start);
+unsigned long _find_next_or_bit(const unsigned long *addr1, const unsigned long *addr2,
+					unsigned long nbits, unsigned long start);
 unsigned long _find_next_zero_bit(const unsigned long *addr, unsigned long nbits,
 					 unsigned long start);
 extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
@@ -127,6 +129,36 @@ unsigned long find_next_andnot_bit(const unsigned long *addr1,
 }
 #endif
 
+#ifndef find_next_or_bit
+/**
+ * find_next_or_bit - find the next set bit in either memory regions
+ * @addr1: The first address to base the search on
+ * @addr2: The second address to base the search on
+ * @size: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_next_or_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long size,
+		unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = (*addr1 | *addr2) & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_next_or_bit(addr1, addr2, size, offset);
+}
+#endif
+
 #ifndef find_next_zero_bit
 /**
  * find_next_zero_bit - find the next cleared bit in a memory region
@@ -536,6 +568,11 @@ unsigned long find_next_bit_le(const void *addr, unsigned
 	     (bit) = find_next_andnot_bit((addr1), (addr2), (size), (bit)), (bit) < (size);\
 	     (bit)++)
 
+#define for_each_or_bit(bit, addr1, addr2, size) \
+	for ((bit) = 0;									\
+	     (bit) = find_next_or_bit((addr1), (addr2), (size), (bit)), (bit) < (size);\
+	     (bit)++)
+
 /* same as for_each_set_bit() but use bit as value to start with */
 #define for_each_set_bit_from(bit, addr, size) \
 	for (; (bit) = find_next_bit((addr), (size), (bit)), (bit) < (size); (bit)++)
diff --git a/lib/find_bit.c b/lib/find_bit.c
index c10920e66788..32f99e9a670e 100644
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -182,6 +182,15 @@ unsigned long _find_next_andnot_bit(const unsigned long *addr1, const unsigned l
 EXPORT_SYMBOL(_find_next_andnot_bit);
 #endif
 
+#ifndef find_next_or_bit
+unsigned long _find_next_or_bit(const unsigned long *addr1, const unsigned long *addr2,
+					unsigned long nbits, unsigned long start)
+{
+	return FIND_NEXT_BIT(addr1[idx] | addr2[idx], /* nop */, nbits, start);
+}
+EXPORT_SYMBOL(_find_next_or_bit);
+#endif
+
 #ifndef find_next_zero_bit
 unsigned long _find_next_zero_bit(const unsigned long *addr, unsigned long nbits,
 					 unsigned long start)
-- 
2.39.2

