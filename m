Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A592FACBE
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Jan 2021 22:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438121AbhARVeZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 Jan 2021 16:34:25 -0500
Received: from sandeen.net ([63.231.237.45]:59678 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438110AbhARVeY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 16:34:24 -0500
Received: from liberator.local (unknown [10.0.1.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 35424323C16;
        Mon, 18 Jan 2021 15:31:59 -0600 (CST)
Subject: Re: [PATCH v2 0/6] debian: xfsprogs package clean-up
To:     Bastian Germann <bastiangermann@fishpost.de>,
        linux-xfs@vger.kernel.org
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <49ecc92b-6f67-5938-af41-209a0e303e8e@sandeen.net>
Date:   Mon, 18 Jan 2021 15:33:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210116092328.2667-1-bastiangermann@fishpost.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/16/21 3:23 AM, Bastian Germann wrote:
> Apply some minor changes to the xfsprogs debian packages, including
> missing copyright notices that are required by Debian Policy.
> 
> v2:
>   resend with Reviewed-by annotations applied, Nathan actually sent:
>   "Signed-off-by: Nathan Scott <nathans@debian.org>"

I've pushed these, plus Nathan's patch to add you to Uploaders

Thanks,
-Eric

> Bastian Germann (6):
>   debian: cryptographically verify upstream tarball
>   debian: remove dependency on essential util-linux
>   debian: remove "Priority: extra"
>   debian: use Package-Type over its predecessor
>   debian: add missing copyright info
>   debian: new changelog entry
> 
>  debian/changelog                |  11 ++++
>  debian/control                  |   5 +-
>  debian/copyright                | 111 ++++++++++++++++++++++++++++----
>  debian/upstream/signing-key.asc |  63 ++++++++++++++++++
>  debian/watch                    |   2 +-
>  5 files changed, 175 insertions(+), 17 deletions(-)
>  create mode 100644 debian/upstream/signing-key.asc
> 
