Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DBC380175
	for <lists+linux-xfs@lfdr.de>; Fri, 14 May 2021 03:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhENBWh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 May 2021 21:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhENBWg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 May 2021 21:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20A69613CD
        for <linux-xfs@vger.kernel.org>; Fri, 14 May 2021 01:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620955286;
        bh=TmKJ3HIUdIee67vi2UtWzDaoiJZGQmWLMr3TUhk9oPI=;
        h=Date:From:To:Subject:From;
        b=bZhT68DrRK9yRhqmTsroZsw1o653Om50QvSqdNPItatLjEZfEy/vflHWCI7dsWFgt
         AHaaY6JUai0CqnjnaedKkX9ldsannL5ItcMMsQ3fWG8xEq0XAfVj8bqDzmsiEM/ZJl
         tdcWiAWCY+KOU/dRlGWbrbw5HLZUOvhO4AMFOJWtRfst1OPYwPMhT8ZTo8b+Ias+PQ
         fjTJ8cQwzOwUzV4G2O8Bs5g0bNVTaZJHXMY8Apq2J+h7UeNO1GJ5UgnWCjx6mOy6U2
         rffuD6g1E1ZpTfSxEysdPOh9gE49rpZupbbfj1mAdR+OtUWeW1UuGuj0SyCqr89kcW
         rkG8MjtBgZElg==
Date:   Thu, 13 May 2021 18:21:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: no xfs-5.13-fixes branch yet
Message-ID: <20210514012125.GI9675@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

Just FYI, I decided not to move forward with a -fixes branch based on
5.13-rc1 because of the data corruptions reported with bfq[1] and
dm-crypt[2].  Hopefully at least the first one will get fixed in rc2 and
I'll base it off that.  I didn't feel like torching peoples' testing VMs
like last cycle.

Also I might be out Tuesday and Wednesday of next week.

--D

[1] https://lore.kernel.org/linux-block/20210512094352.85545-1-paolo.valente@linaro.org/
[2] https://lore.kernel.org/linux-ext4/20210513094222.17635-1-nanich.lee@samsung.com/
