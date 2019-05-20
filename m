Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A18023CEC
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbfETQMD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 12:12:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54670 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733161AbfETQMC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 12:12:02 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF7CD8830C;
        Mon, 20 May 2019 16:12:02 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 76B0E2DE91;
        Mon, 20 May 2019 16:12:02 +0000 (UTC)
Date:   Mon, 20 May 2019 12:12:00 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 203655] XFS: Assertion failed: 0, xfs_log_recover.c, line:
 551
Message-ID: <20190520161200.GB32784@bfoster>
References: <bug-203655-201763@https.bugzilla.kernel.org/>
 <bug-203655-201763-WLgC3hGYRF@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-203655-201763-WLgC3hGYRF@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 20 May 2019 16:12:02 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 04:02:06PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=203655
> 
> Eric Sandeen (sandeen@sandeen.net) changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |sandeen@sandeen.net
> 
> --- Comment #2 from Eric Sandeen (sandeen@sandeen.net) ---
> I think the question here is whether the ASSERT() is valid - we don't ever want
> to assert on disk corruption, it should only be for "this should never happen
> in the code" scenarios.
> 

Makes sense. It's not clear to me whether that's the intent of the bug,
but regardless I think it would be reasonable to kill off that
particular assert. We already warn and return an error.

Brian

> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
