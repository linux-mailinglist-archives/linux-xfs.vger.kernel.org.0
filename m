Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA95E1BA4C
	for <lists+linux-xfs@lfdr.de>; Mon, 13 May 2019 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfEMPoh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 May 2019 11:44:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbfEMPog (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 May 2019 11:44:36 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82FB6C04FFEF;
        Mon, 13 May 2019 15:44:36 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C115608AB;
        Mon, 13 May 2019 15:44:36 +0000 (UTC)
Date:   Mon, 13 May 2019 11:44:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: refactor small allocation helper to skip cntbt
 attempt
Message-ID: <20190513154433.GD61135@bfoster>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-2-bfoster@redhat.com>
 <20190510172446.GA18992@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510172446.GA18992@infradead.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 13 May 2019 15:44:36 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 10:24:46AM -0700, Christoph Hellwig wrote:
> This looks pretty sensible to me.  What confuses me a bit is that
> the patch is much more (good!) refactoring than the actual change.
> 
> If you have to respin it maybe split it up, making the actual
> behavior change even more obvious.
> 

The only functional change was basically to check for ccur before using
it and initializing i to zero. It just seemed to make sense to clean up
the surrounding code while there, but I can either split out the
aesthetic cleanup or defer that stuff to the broader rework at the end
of the series (where the cursor stuff just gets ripped out anyways) if
either of those is cleaner..

Brian

> Otherwise:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
