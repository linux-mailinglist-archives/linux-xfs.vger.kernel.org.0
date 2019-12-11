Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E2311BA7C
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Dec 2019 18:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfLKRim (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Dec 2019 12:38:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729524AbfLKRim (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 12:38:42 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBHcUik062700
        for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2019 12:38:41 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wthkj20q4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2019 12:38:40 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <srikar@linux.vnet.ibm.com>;
        Wed, 11 Dec 2019 17:38:38 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Dec 2019 17:38:33 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBBHcWhP63242242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 17:38:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACD9011C04A;
        Wed, 11 Dec 2019 17:38:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 029AA11C050;
        Wed, 11 Dec 2019 17:38:30 +0000 (GMT)
Received: from linux.vnet.ibm.com (unknown [9.126.150.29])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 11 Dec 2019 17:38:29 +0000 (GMT)
Date:   Wed, 11 Dec 2019 23:08:29 +0530
From:   Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To:     Dave Chinner <david@fromorbit.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Phil Auld <pauld@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v4] sched/core: Preempt current task in favour of bound
 kthread
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20191115234005.GO4614@dread.disaster.area>
 <20191118092121.GV4131@hirez.programming.kicks-ass.net>
 <20191118204054.GV4614@dread.disaster.area>
 <20191120191636.GI4097@hirez.programming.kicks-ass.net>
 <20191120220313.GC18056@pauld.bos.csb>
 <20191121132937.GW4114@hirez.programming.kicks-ass.net>
 <20191209165122.GA27229@linux.vnet.ibm.com>
 <20191209231743.GA19256@dread.disaster.area>
 <20191210054330.GF27253@linux.vnet.ibm.com>
 <20191210172307.GD9139@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20191210172307.GD9139@linux.vnet.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-TM-AS-GCONF: 00
x-cbid: 19121117-0028-0000-0000-000003C79DF3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121117-0029-0000-0000-0000248AD41E
Message-Id: <20191211173829.GB21797@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_05:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0 suspectscore=2
 spamscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A running task can wake-up a per CPU bound kthread on the same CPU.
If the current running task doesn't yield the CPU before the next load
balance operation, the scheduler would detect load imbalance and try to
balance the load. However this load balance would fail as the waiting
task is CPU bound, while the running task cannot be moved by the regular
load balancer. Finally the active load balancer would kick in and move
the task to a different CPU/Core. Moving the task to a different
CPU/core can lead to loss in cache affinity leading to poor performance.

This is more prone to happen if the current running task is CPU
intensive and the sched_wake_up_granularity is set to larger value.
When the sched_wake_up_granularity was relatively small, it was observed
that the bound thread would complete before the load balancer would have
chosen to move the cache hot task to a different CPU.

To deal with this situation, the current running task would yield to a
per CPU bound kthread, provided kthread is not CPU intensive.

/pboffline/hwcct_prg_old/lib/fsperf -t overwrite --noclean -f 5g -b 4k /pboffline

(With sched_wake_up_granularity set to 15ms)

Performance counter stats for 'system wide' (5 runs):
event					    v5.4 				v5.4 + patch(v3)
probe:active_load_balance_cpu_stop       1,919  ( +-  2.89% )                     4  ( +- 20.48% )
sched:sched_waking                     441,535  ( +-  0.17% )               914,630  ( +-  0.18% )
sched:sched_wakeup                     441,533  ( +-  0.17% )               914,630  ( +-  0.18% )
sched:sched_wakeup_new                   2,436  ( +-  8.08% )                   545  ( +-  4.02% )
sched:sched_switch                     797,007  ( +-  0.26% )             1,490,261  ( +-  0.10% )
sched:sched_migrate_task                20,998  ( +-  1.04% )                 2,492  ( +- 11.56% )
sched:sched_process_free                 2,436  ( +-  7.90% )                   526  ( +-  3.65% )
sched:sched_process_exit                 2,451  ( +-  7.85% )                   546  ( +-  4.06% )
sched:sched_wait_task                        7  ( +- 21.20% )                     1  ( +- 40.82% )
sched:sched_process_wait                 3,951  ( +-  9.14% )                   854  ( +-  5.33% )
sched:sched_process_fork                 2,435  ( +-  8.09% )                   545  ( +-  3.96% )
sched:sched_process_exec                 1,023  ( +- 12.21% )                   205  ( +-  5.13% )
sched:sched_wake_idle_without_ipi      187,794  ( +-  1.14% )               353,579  ( +-  0.42% )

Elasped time in seconds          289.43 +- 1.42 ( +-  0.49% )      72.7318 +- 0.0545 ( +-  0.07% )

Throughput results

v5.4
Trigger time:................... 0.842679 s   (Throughput:     6075.86 MB/s)
Asynchronous submit time:.......   1.0184 s   (Throughput:     5027.49 MB/s)
Synchronous submit time:........        0 s   (Throughput:           0 MB/s)
I/O time:.......................   263.17 s   (Throughput:      19.455 MB/s)
Ratio trigger time to I/O time:.0.00320202

v5.4 + patch(v3)
Trigger time:................... 0.852413 s   (Throughput:     6006.47 MB/s)
Asynchronous submit time:....... 0.773043 s   (Throughput:     6623.17 MB/s)
Synchronous submit time:........        0 s   (Throughput:           0 MB/s)
I/O time:.......................   44.341 s   (Throughput:     115.468 MB/s)
Ratio trigger time to I/O time:. 0.019224

(With sched_wake_up_granularity set to 4ms)

Performance counter stats for 'system wide' (5 runs):
event					      v5.4 				    v5.4 + patch(v3)
probe:active_load_balance_cpu_stop               6  ( +-  6.03% )                      5  ( +- 15.04% )
sched:sched_waking                         899,880  ( +-  0.38% )                912,625  ( +-  0.41% )
sched:sched_wakeup                         899,878  ( +-  0.38% )                912,624  ( +-  0.41% )
sched:sched_wakeup_new                         622  ( +- 11.95% )                    550  ( +-  3.85% )
sched:sched_switch                       1,458,214  ( +-  0.40% )              1,489,032  ( +-  0.41% )
sched:sched_migrate_task                     3,120  ( +- 10.00% )                  2,524  ( +-  5.54% )
sched:sched_process_free                       608  ( +- 12.18% )                    528  ( +-  3.89% )
sched:sched_process_exit                       623  ( +- 11.91% )                    550  ( +-  3.79% )
sched:sched_wait_task                            1  ( +- 31.18% )                      1  ( +- 66.67% )
sched:sched_process_wait                       998  ( +- 13.22% )                    867  ( +-  4.41% )
sched:sched_process_fork                       622  ( +- 11.95% )                    550  ( +-  3.88% )
sched:sched_process_exec                       242  ( +- 13.81% )                    208  ( +-  4.57% )
sched:sched_wake_idle_without_ipi          349,165  ( +-  0.35% )                352,443  ( +-  0.21% )

Elasped time in seconds           72.8560 +- 0.0768 ( +-  0.11% )        72.5523 +- 0.0725 ( +-  0.10% )

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
Changelog:
v1 : http://lore.kernel.org/lkml/20191209165122.GA27229@linux.vnet.ibm.com
v2 : http://lore.kernel.org/lkml/20191210054330.GF27253@linux.vnet.ibm.com
v3 : http://lore.kernel.org/lkml/20191210172307.GD9139@linux.vnet.ibm.com
v1->v2: Pass the the right params to try_to_wake_up as correctly pointed out
	by Dave Chinner
v2->v3: Suggestions from Peter Zijlstra including using vtime over
	context switch and detect per-cpu-kthread in try_to_wake_up
v3->v4: Fixed a compilation failed under !CONFIG_SMP reported by
	kbuild test robot <lkp@intel.com> as is_per_cpu_kthread is only
	defined for CONFIG_SMP.

 kernel/sched/core.c  | 5 +++++
 kernel/sched/fair.c  | 2 +-
 kernel/sched/sched.h | 3 ++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 44123b4d14e8..2636002e4a0d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2542,6 +2542,11 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		goto out;
 	}
 
+#ifdef CONFIG_SMP
+	if (is_per_cpu_kthread(p))
+		wake_flags |= WF_KTHREAD;
+#endif
+
 	/*
 	 * If we are going to wake up a thread waiting for CONDITION we
 	 * need to ensure that CONDITION=1 done by the caller can not be
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 69a81a5709ff..8fe40f83804d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6716,7 +6716,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	find_matching_se(&se, &pse);
 	update_curr(cfs_rq_of(se));
 	BUG_ON(!pse);
-	if (wakeup_preempt_entity(se, pse) == 1) {
+	if (wakeup_preempt_entity(se, pse) >= !(wake_flags & WF_KTHREAD)) {
 		/*
 		 * Bias pick_next to pick the sched entity that is
 		 * triggering this preemption.
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c8870c5bd7df..fcd1ed5af9a3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1643,7 +1643,8 @@ static inline int task_on_rq_migrating(struct task_struct *p)
  */
 #define WF_SYNC			0x01		/* Waker goes to sleep after wakeup */
 #define WF_FORK			0x02		/* Child wakeup after fork */
-#define WF_MIGRATED		0x4		/* Internal use, task got migrated */
+#define WF_MIGRATED		0x04		/* Internal use, task got migrated */
+#define WF_KTHREAD		0x08		/* Per CPU Kthread */
 
 /*
  * To aid in avoiding the subversion of "niceness" due to uneven distribution
-- 
2.18.1

