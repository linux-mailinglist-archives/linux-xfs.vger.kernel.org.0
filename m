Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED8F7AFC21
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Sep 2023 09:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjI0HeM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 27 Sep 2023 03:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjI0HeL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Sep 2023 03:34:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B418CBF
        for <linux-xfs@vger.kernel.org>; Wed, 27 Sep 2023 00:34:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C310CC433C7;
        Wed, 27 Sep 2023 07:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695800050;
        bh=SciR2ARKlhYHe8eaTu2M9Tds1+GSB7T4PEknNcPiuQ8=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=MbldrKrny1Rn5dz9fDTc1ZzG6GuYjze5HvG/TjB705qOhHSp4tNMum5pcUH4rfmFh
         rRauN2lYflZ22PkdFpcT6TxEscGVqschHROghh+Sgyeusb/X7mxXdbLAfhZp2Zv2vE
         yEa1d7lFMrJPZn/8Ds4Bm0yVNZFA5VNEnJzbrgU5bn5beiqT5GrB32NoigWHlkts87
         CzSSxCy7DA2d9DbnaJl9lEkqmXH1F/9q/VhQvsOAwYkdhAjaEfRy7QKsQPnTuYRa2d
         DpE+Ztcqrzpw+fdlTyrQoubhvyVVgyup3+Y8AwjUWWKAUfwteksWXvNffufxwMykOj
         DgTQUbbkvqWFA==
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
 <20230926145519.GE11439@frogsfrogsfrogs>
 <ZROC8hEabAGS7orb@dread.disaster.area>
 <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
        dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Date:   Wed, 27 Sep 2023 13:01:25 +0530
In-reply-to: <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
Message-ID: <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



=E5=9C=A8 2023/9/27 13:17, Shiyang Ruan =E5=86=99=E9=81=93:
>=20
> =E5=9C=A8 2023/9/27 11:38, Chandan Babu R =E5=86=99=E9=81=93:
>> On Tue, Sep 26, 2023 at 06:46:32 PM -0700, Darrick J. Wong wrote:
>>> On Wed, Sep 27, 2023 at 11:18:42AM +1000, Dave Chinner wrote:
>>>> On Tue, Sep 26, 2023 at 07:55:19AM -0700, Darrick J. Wong wrote:
>>>>> On Thu, Sep 21, 2023 at 04:33:04PM +0800, Shiyang Ruan wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Any comments?
>>>>>
>>>>> I notice that xfs/55[0-2] still fail on my fakepmem machine:
>>>>>
>>>>> --- /tmp/fstests/tests/xfs/550.out=C2=A0=C2=A0=C2=A0 2023-09-23
>>>>> 09:40:47.839521305 -0700
>>>>> +++ /var/tmp/fstests/xfs/550.out.bad=C2=A0=C2=A0=C2=A0 2023-09-24
>>>>> 20:00:23.400000000 -0700
>>>>> @@ -3,7 +3,6 @@ Format and mount
>>>>> =C2=A0 Create the original files
>>>>> =C2=A0 Inject memory failure (1 page)
>>>>> =C2=A0 Inject poison...
>>>>> -Process is killed by signal: 7
>>>>> =C2=A0 Inject memory failure (2 pages)
>>>>> =C2=A0 Inject poison...
>>>>> -Process is killed by signal: 7
>>>>> +Memory failure didn't kill the process
>>>>>
>>>>> (yes, rmap is enabled)
>>>>
>>>> Yes, I see the same failures, too. I've just been ignoring them
>>>> because I thought that all the memory failure code was still not
>>>> complete....
>>>
>>> Oh, I bet we were supposed to have merged this
>>>
>>> https://lore.kernel.org/linux-xfs/20230828065744.1446462-1-ruansy.fnst@=
fujitsu.com/

FYI, this one is in Andrew's mm-unstable tree:

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=3Dmm-=
unstable&id=3Dff048e3e2d167927634a45f4f424338411a1c4e6


>>>
>>> to complete the pmem media failure handling code.=C2=A0 Should we (by w=
hich I
>>> mostly mean Shiyang) ask Chandan to merge these two patches for 6.7?
>>>
>>
>> I can add this patch into XFS tree for 6.7. But I will need Acks
>> from Andrew
>> Morton and Dan Williams.

To clarify further, I will need Acked-By for the patch at
https://lore.kernel.org/linux-xfs/20230828065744.1446462-1-ruansy.fnst@fuji=
tsu.com/

--=20
Chandan
