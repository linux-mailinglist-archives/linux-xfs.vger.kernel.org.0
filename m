Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781E8278B3D
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Sep 2020 16:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbgIYOur (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Sep 2020 10:50:47 -0400
Received: from sandeen.net ([63.231.237.45]:35284 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbgIYOur (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Sep 2020 10:50:47 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 77E14EDD;
        Fri, 25 Sep 2020 09:50:08 -0500 (CDT)
To:     Pavel Reichl <preichl@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200924170747.65876-1-preichl@redhat.com>
 <20200924170747.65876-2-preichl@redhat.com> <20200924172600.GG7955@magnolia>
 <be017461-6ce9-1d64-51d6-7e85a3e45055@sandeen.net>
 <20200924174913.GI7955@magnolia>
 <bebb2448-2b0e-6a39-79b2-18b6fb8811ee@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] xfs: remove deprecated mount options
Message-ID: <f5dddb95-100d-2497-40d5-8ff1e8ae2617@sandeen.net>
Date:   Fri, 25 Sep 2020 09:50:45 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <bebb2448-2b0e-6a39-79b2-18b6fb8811ee@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/25/20 8:40 AM, Pavel Reichl wrote:
> Thanks for discussion, if I get it right, the only thing to change is to add the date when mount options will me removed (September 2025)?

Please also add a comment above the moved mount options indicating that
all options below the comment are slated for deprecation.

Not sure if Darrick had anything else.  Are we happy w/ the kernel logging?
