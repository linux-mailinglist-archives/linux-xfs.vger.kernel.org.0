Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC26242E2
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 23:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfETVbP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 17:31:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfETVbP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 17:31:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4279A307BA56;
        Mon, 20 May 2019 21:31:10 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD29660BEC;
        Mon, 20 May 2019 21:31:08 +0000 (UTC)
Subject: Re: [PATCH] xfs: remove unused flag arguments
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <ed89244f-cc3a-6bcf-316c-68edc8aee4cc@redhat.com>
 <20190520212139.GC5335@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <a0756ae7-eb4d-c25a-a567-d8d27301d12b@redhat.com>
Date:   Mon, 20 May 2019 16:31:08 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520212139.GC5335@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 20 May 2019 21:31:15 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/20/19 4:21 PM, Darrick J. Wong wrote:
> On Wed, May 15, 2019 at 01:37:32PM -0500, Eric Sandeen wrote:
>> There are several functions which take a flag argument that is
>> only ever passed as "0," so remove these arguments.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> (motivated by simplifying userspace libxfs, TBH)
>>
>>  libxfs/xfs_ag.c          |    8 ++++----
>>  libxfs/xfs_alloc.c       |    4 ++--
>>  libxfs/xfs_attr_remote.c |    2 +-
>>  libxfs/xfs_bmap.c        |   14 +++++++-------
>>  libxfs/xfs_btree.c       |   30 +++++++++++-------------------
>>  libxfs/xfs_btree.h       |   10 +++-------
>>  libxfs/xfs_sb.c          |    2 +-
>>  scrub/repair.c           |    2 +-
>>  xfs_bmap_util.c          |    6 +++---
>>  xfs_buf.h                |    5 ++---
> 
> Do you have an accompanying xfsprogs patch up your sleeve somewhere too?
> :)

yeah it's on the list, trying to decide if I want to wait and
libxfs-merge this or just do it since IIRC it's kind of in the way
of my other xfsprogs patches...

Thanks,
-Eric

