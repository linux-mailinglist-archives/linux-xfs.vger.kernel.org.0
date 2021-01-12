Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991F02F3F88
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Jan 2021 01:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732232AbhALWvG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Tue, 12 Jan 2021 17:51:06 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:48693 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbhALWvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 17:51:06 -0500
X-Originating-IP: 86.192.251.148
Received: from [192.168.1.42] (lfbn-lil-1-1020-148.w86-192.abo.wanadoo.fr [86.192.251.148])
        (Authenticated sender: bastien@esrevart.net)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 58CC61BF207;
        Tue, 12 Jan 2021 22:50:25 +0000 (UTC)
Date:   Tue, 12 Jan 2021 23:50:19 +0100
From:   Bastien Traverse <bastien@esrevart.net>
Subject: Re: [BUG] xfs_corruption_error after creating a swap file
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Message-Id: <VFFUMQ.9RG39DGXEE5F@esrevart.net>
In-Reply-To: <20210112222558.GV331610@dread.disaster.area>
References: <TMAUMQ.RILVCKL2FQ501@esrevart.net>
        <20210112222558.GV331610@dread.disaster.area>
X-Mailer: geary/3.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Le mer. 13 janv. 2021 à 9:25, Dave Chinner <david@fromorbit.com> a 
écrit :

 > But I thought that was fixed in 5.9-rc7 so should be in your kernel.
 > Can you confirm that your kernel has this fix?

This commit does appear in Arch kernel repo, so I can only suppose it's 
in: 
https://git.archlinux.org/linux.git/commit/?id=41663430588c737dd735bad5a0d1ba325dcabd59

Arch tends to stay close to upstream and I am using the standard kernel.

Thanks,
Bastien



