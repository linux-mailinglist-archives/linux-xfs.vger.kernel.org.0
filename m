Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3561FFD01E
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Nov 2019 22:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfKNVJe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 14 Nov 2019 16:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbfKNVJe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Nov 2019 16:09:34 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1E9D206E1;
        Thu, 14 Nov 2019 21:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573765774;
        bh=oIO406Twc3m5BIxEir0m1cNXIzYnyo683FesNyVYicI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RHfNy12QtQyWlefOUupe1Ha0MLPawk3H6Xih3liaZ0sDTPEJh0w6lKwHz9zVIY/5a
         vVVlo+zVXLM+65jm8ONDGDzEruj7MTQJ+qY+7L34Wu3lTT1FJfDS1V37JUac8MqxTH
         Nr8ETBWzd3Ra/WdzLjoXvXBhW55uxM8SjVhX6ePs=
Date:   Thu, 14 Nov 2019 13:09:32 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: fix memory leak in add_enckey
Message-ID: <20191114210931.GA214524@gmail.com>
References: <4eb1073f-91fb-a4bc-aae8-d54dc5a6b8aa@redhat.com>
 <20191107214606.GA1160@google.com>
 <2b089dfc-8961-742d-2bab-9b5b471dc26f@sandeen.net>
 <a142f525-c45f-c245-58ad-879f94a636cb@sandeen.net>
 <20191111172737.GB56300@gmail.com>
 <b2e750d0-7342-0e75-7c6a-a374c1181f53@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2e750d0-7342-0e75-7c6a-a374c1181f53@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 11, 2019 at 12:07:27PM -0600, Eric Sandeen wrote:
> > 
> > Sorry, I didn't receive this because I was dropped from Cc, and I'm not
> > currently subscribed to linux-xfs.  The patch you committed looks fine, thanks.
> 
> Oh, I'm sorry about that, my mistake.
> 

And it happened again :-)

For the record, this seems to have been my fault.  My .muttrc was missing
	
	set followup_to = no
	
and at some point I had added mailing list declarations including:

	subscribe .*@vger.kernel.org
	
so Mutt was generating a Mail-Followup-To header excluding me.  I hadn't noticed
this problem earlier because I'm normally subscribed to one of the lists anyway.

- Eric
