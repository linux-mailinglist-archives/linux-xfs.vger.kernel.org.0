Return-Path: <linux-xfs+bounces-2749-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3573682B69A
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jan 2024 22:25:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 875FA283FD2
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jan 2024 21:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1DE58AA2;
	Thu, 11 Jan 2024 21:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ugXSvcPb"
X-Original-To: linux-xfs@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B08758212;
	Thu, 11 Jan 2024 21:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=h5JRxZmfjqOYZZRAvRI1Cwt+9QteJXdUxDRr8ebrX5I=; b=ugXSvcPbPDTMiiIY8MjQ/FEQyf
	j3wIORkZgDASPDZrAeyTJLPHae7YoeOIPuXQyz6T5xwxRYQtGLRwZ2NBqCXHF68rdTNgK2JkKql8l
	YBFtQth0SXlGA9tmI70yaZFUQgfnP3+14C7BBj308g2XbFt7WiB1p1yC2yuqhP3oME15RRmYhtv6d
	6NgmlogEx64E4Ko4vVH1K5NMudBEFM+Rxk0tpcYYfHVlHPu/tWeFGSpWYQ7hj+r4CVwDMiSw7ggH8
	Q6w5Bts9mCAUtcZbKTped29C/6bd/5Tc4tusZCcKya6iBPfYfCIcOdJ/yv4H0wniW59TUJy40ar90
	F175KuYw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rO2XO-00EzIG-Go; Thu, 11 Jan 2024 21:24:30 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v5 1/3] locking: Add rwsem_assert_held() and rwsem_assert_held_write()
Date: Thu, 11 Jan 2024 21:24:22 +0000
Message-Id: <20240111212424.3572189-2-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20240111212424.3572189-1-willy@infradead.org>
References: <20240111212424.3572189-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modelled after lockdep_assert_held() and lockdep_assert_held_write(),
but are always active, even when lockdep is disabled.  Of course, they
don't test that _this_ thread is the owner, but it's sufficient to catch
many bugs and doesn't incur the same performance penalty as lockdep.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/rwbase_rt.h |  9 ++++++--
 include/linux/rwsem.h     | 46 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/include/linux/rwbase_rt.h b/include/linux/rwbase_rt.h
index 1d264dd08625..29c4e4f243e4 100644
--- a/include/linux/rwbase_rt.h
+++ b/include/linux/rwbase_rt.h
@@ -26,12 +26,17 @@ struct rwbase_rt {
 	} while (0)
 
 
-static __always_inline bool rw_base_is_locked(struct rwbase_rt *rwb)
+static __always_inline bool rw_base_is_locked(const struct rwbase_rt *rwb)
 {
 	return atomic_read(&rwb->readers) != READER_BIAS;
 }
 
-static __always_inline bool rw_base_is_contended(struct rwbase_rt *rwb)
+static inline void rw_base_assert_held_write(const struct rwbase_rt *rwb)
+{
+	WARN_ON(atomic_read(&rwb->readers) != WRITER_BIAS);
+}
+
+static __always_inline bool rw_base_is_contended(const struct rwbase_rt *rwb)
 {
 	return atomic_read(&rwb->readers) > 0;
 }
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 9c29689ff505..4f1c18992f76 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -66,14 +66,24 @@ struct rw_semaphore {
 #endif
 };
 
-/* In all implementations count != 0 means locked */
+#define RWSEM_UNLOCKED_VALUE		0UL
+#define RWSEM_WRITER_LOCKED		(1UL << 0)
+#define __RWSEM_COUNT_INIT(name)	.count = ATOMIC_LONG_INIT(RWSEM_UNLOCKED_VALUE)
+
 static inline int rwsem_is_locked(struct rw_semaphore *sem)
 {
-	return atomic_long_read(&sem->count) != 0;
+	return atomic_long_read(&sem->count) != RWSEM_UNLOCKED_VALUE;
 }
 
-#define RWSEM_UNLOCKED_VALUE		0L
-#define __RWSEM_COUNT_INIT(name)	.count = ATOMIC_LONG_INIT(RWSEM_UNLOCKED_VALUE)
+static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
+{
+	WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
+}
+
+static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
+{
+	WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
+}
 
 /* Common initializer macros and functions */
 
@@ -152,11 +162,21 @@ do {								\
 	__init_rwsem((sem), #sem, &__key);			\
 } while (0)
 
-static __always_inline int rwsem_is_locked(struct rw_semaphore *sem)
+static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
 {
 	return rw_base_is_locked(&sem->rwbase);
 }
 
+static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
+{
+	WARN_ON(!rwsem_is_locked(sem));
+}
+
+static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
+{
+	rw_base_assert_held_write(sem);
+}
+
 static __always_inline int rwsem_is_contended(struct rw_semaphore *sem)
 {
 	return rw_base_is_contended(&sem->rwbase);
@@ -169,6 +189,22 @@ static __always_inline int rwsem_is_contended(struct rw_semaphore *sem)
  * the RT specific variant.
  */
 
+static inline void rwsem_assert_held(const struct rw_semaphore *sem)
+{
+	if (IS_ENABLED(CONFIG_LOCKDEP))
+		lockdep_assert_held(sem);
+	else
+		rwsem_assert_held_nolockdep(sem);
+}
+
+static inline void rwsem_assert_held_write(const struct rw_semaphore *sem)
+{
+	if (IS_ENABLED(CONFIG_LOCKDEP))
+		lockdep_assert_held_write(sem);
+	else
+		rwsem_assert_held_write_nolockdep(sem);
+}
+
 /*
  * lock for reading
  */
-- 
2.43.0


