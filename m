Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1E82D8225
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Dec 2020 23:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406935AbgLKWcT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 11 Dec 2020 17:32:19 -0500
Received: from sandeen.net ([63.231.237.45]:55724 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406951AbgLKWbx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Dec 2020 17:31:53 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D359C15D6C
        for <linux-xfs@vger.kernel.org>; Fri, 11 Dec 2020 16:30:27 -0600 (CST)
From:   Eric Sandeen <sandeen@sandeen.net>
To:     xfs <linux-xfs@vger.kernel.org>
References: <a4de41d3-6751-7227-0d20-e54aca182758@sandeen.net>
Subject: Re: [ANNOUNCE] xfsprogs v5.10.0 released, master branch updated to
 25d27711
Message-ID: <a766c47a-b5f1-f760-236b-d365efff200b@sandeen.net>
Date:   Fri, 11 Dec 2020 16:31:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <a4de41d3-6751-7227-0d20-e54aca182758@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/11/20 4:25 PM, Eric Sandeen wrote:
> Hi folks,
> 
> The master branch of the xfsprogs repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated and tagged with v5.10.0

One thing I should have noted in the original email is that this release's
support for mkfs configuration files now requires the "inih" ini file
parser library; libinih-dev in Debian, inih-devel in Fedora, etc.

Thanks,
-Eric
