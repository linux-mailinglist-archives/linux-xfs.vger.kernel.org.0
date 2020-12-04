Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938E82CF60D
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Dec 2020 22:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgLDVRU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 4 Dec 2020 16:17:20 -0500
Received: from sandeen.net ([63.231.237.45]:42208 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbgLDVRU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Dec 2020 16:17:20 -0500
Received: from liberator.sandeen.net (usg [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1E6877906;
        Fri,  4 Dec 2020 15:16:19 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <20201204011330.GC629293@magnolia>
 <19330785-5ed2-2fc0-cad5-63a350a2c579@sandeen.net>
 <20201204210901.GD106271@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/3] xfs_db: support the needsrepair feature flag in the
 version command
Message-ID: <27d9f6de-7827-b43e-3ed2-ee098e5dd6ac@sandeen.net>
Date:   Fri, 4 Dec 2020 15:16:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204210901.GD106271@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/4/20 3:09 PM, Darrick J. Wong wrote:
>>> @@ -543,6 +549,12 @@ label_f(
>>>  			return 0;
>>>  		}
>>>  
>>> +		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
>>> +			dbprintf(_("%s: filesystem needs xfs_repair\n"),
>>> +				progname);
>>> +			return 0;
>>> +		}
>>> +
>> why are uuid_f and label_f uniquely disallowed from operating on a needsrepair
>> filesystem?  (is it because they are unique in that they rewrite all superblocks?)
> Because ... the fs needs repair, so the admin should repair the fs
> before they try to modify the fs.  We don't allow mounting, so we
> shouldn't allow label/uuid changes.

But xfs_db can change LOTS more than just these two things.

So this seems a bit ad-hoc and something that will drift as time
goes by.

So what is the "can't change" criteria here - only xfs_admin-invoked routines?

If so, could we put this in a central place, and reject if
!(strcmp(progname, "xfs_admin")) but let the xfs_db power user proceed?

Mostly I prefer to get this check centralized and not sprinkled around.

-Eric
