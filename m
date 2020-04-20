Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F341B0057
	for <lists+linux-xfs@lfdr.de>; Mon, 20 Apr 2020 05:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbgDTD7C (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 19 Apr 2020 23:59:02 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44896 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725865AbgDTD7C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Apr 2020 23:59:02 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2773E3A37C4;
        Mon, 20 Apr 2020 13:59:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jQNaE-0008KW-2i; Mon, 20 Apr 2020 13:58:58 +1000
Date:   Mon, 20 Apr 2020 13:58:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove unnecessary quotaoff intent item push
 handler
Message-ID: <20200420035858.GK9800@dread.disaster.area>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417150859.14734-9-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=7-415B0cAAAA:8
        a=6Z-vhxyNUeLoRVkCRMAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 17, 2020 at 11:08:55AM -0400, Brian Foster wrote:
> The quotaoff intent item push handler unconditionally returns locked
> status because it remains AIL resident until removed by the
> quotafoff end intent. xfsaild_push_item() already returns pinned
> status for items (generally intents) without a push handler. This is
> effectively the same behavior for the purpose of quotaoff, so remove

It's not the same. XFS_ITEM_PINNED results in a log force from the
xfsaild, while XFS_ITEM_LOCKED items are just skipped. So this
change will result in a log force every time the AIL push sees a
quotaoff log item.  Hence I think the code as it stands is correct
as log forces will not speed up the removal of the quotaoff item
from the AIL...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
