Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07C3E0E23
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Oct 2019 00:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731999AbfJVWYY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 22 Oct 2019 18:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731534AbfJVWYY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Oct 2019 18:24:24 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78847207FC;
        Tue, 22 Oct 2019 22:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571783062;
        bh=ez8tkSR8txCVqD6DpckNBXg+7tEUdjKeAOm63rOmyXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vzTJXRaht4iHlsW9y3944ge5TbrC6yKH9IVjZdFZh5zlGiIOxvngVjxMBBp8h1DHv
         6zVXwLSzEnxzawWaeAXOQLkHPRwO+xtL4GtQIIGtkCSrw0orgCkUg+4aUzZwsKhirT
         UBAyPibXAELSA/0XRbQSVoq0L8Xb2U5f4DhwbXyk=
Date:   Tue, 22 Oct 2019 15:24:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     linux-mm@kvack.org, linux-xfs@vger.kernel.org
Cc:     bugzilla-daemon@bugzilla.kernel.org, goodmirek@goodmirek.com,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        Dmitry Vyukov <dvyukov@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [Bug 205135] System hang up when memory swapping (kswapd
 deadlock)
Message-Id: <20191022152422.e47fda82879dc7cd1f3cf5e5@linux-foundation.org>
In-Reply-To: <bug-205135-27-vbbrgnF9A3@https.bugzilla.kernel.org/>
References: <bug-205135-27@https.bugzilla.kernel.org/>
        <bug-205135-27-vbbrgnF9A3@https.bugzilla.kernel.org/>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Tue, 22 Oct 2019 09:02:22 +0000 bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=205135
> 
> --- Comment #7 from goodmirek@goodmirek.com ---
> Everyone who uses a swapfile on XFS filesystem seem affected by this hang up.
> Not sure about other filesystems, I did not have a chance to test it elsewhere.
> 
> This unreproduced bot crash could be related:
> https://lore.kernel.org/linux-mm/20190910071804.2944-1-hdanton@sina.com/

Thanks.  Might be core MM, might be XFS, might be Fedora.

Hilf, does your patch look related?  That seems to have gone quiet?

Should we progress Tetsuo's patch?
